# frozen_string_literal: true

require 'yabeda/rails'
require 'yabeda/sidekiq'
require 'yabeda/prometheus'
require 'yabeda/puma/plugin'
require 'prometheus/client'

module Monitorbit
  class Railtie < Rails::Railtie
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

    generators do
      require_relative '../generators/monitorbit/install'
    end
  end
end
