# frozen_string_literal: true

require 'yabeda/rails'
require 'yabeda/sidekiq'
require 'yabeda/prometheus'
require 'yabeda/puma/plugin'
require 'prometheus/client'

module Monitorbit
  class Railtie < Rails::Railtie
    LONG_RUNNING_SQL_QUERY_BUCKETS = [
      0.00005, 0.0001, 0.0005, 0.001, 0.0025,
      0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10,
      30, 60, 120, 300, 600
    ].freeze

    initializer 'monitorbit.use_yabeda_prometheus_exporter_middleware' do |app|
      app.middleware.use Yabeda::Prometheus::Exporter
    end

    initializer 'monitorbit.set_up_sidekiq' do |_app|
      Sidekiq.configure_server { |_config| Yabeda::Prometheus::Exporter.start_metrics_server! }
    end

    initializer 'monitorbit.install_yabeda_rails' do |_app|
      Yabeda::Rails.install! unless ::Rails.const_defined?(:Server) || ::Rails.const_defined?('Puma::CLI')
    end

    initializer 'monitorbit.set_up_4xx_5xx_errors' do |_app|
      Yabeda.configure do
        group :monitorbit

        counter :errors_total, comment: 'A counter of the total number of 4xx and 5xx server responses.'

        ActiveSupport::Notifications.subscribe 'monitorbit.4xx_5xx_errors' do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          labels = {
            path: event.payload[:path],
            ip: event.payload[:ip],
            params: event.payload[:params],
            method: event.payload[:method],
            status: event.payload[:status]
          }

          monitorbit_errors_total.increment(labels)
        end
      end
    end

    initializer 'sql.active_record' do |_app|
      Yabeda.configure do
        group :monitorbit

        histogram(
          :sql_query_duration,
          unit: :seconds,
          buckets: LONG_RUNNING_SQL_QUERY_BUCKETS,
          comment: 'A histogram of the query duration.'
        )

        ActiveSupport::Notifications.subscribe 'sql.active_record' do |name, started, finished, unique_id, data|
          event = ActiveSupport::Notifications::Event.new(name, started, finished, unique_id, data)

          duration = finished - started
          labels = {
            sql: event.payload[:sql],
            name: event.payload[:name],
            statement_name: event.payload[:statement_name],
            duration: duration
          }

          monitorbit_sql_query_duration.measure(labels, duration)
        end
      end
    end

    generators do
      require_relative '../generators/monitorbit/install'
    end
  end
end
