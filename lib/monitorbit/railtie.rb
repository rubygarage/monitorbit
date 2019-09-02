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

    initializer 'monitorbit.set_up_sidekiq' do |app|
      Sidekiq.configure_server { |config| Yabeda::Prometheus::Exporter.start_metrics_server! }
    end

    initializer 'monitorbit.install_yabeda_rails' do |app|
      Yabeda::Rails.install! unless ::Rails.const_defined?(:Server) || ::Rails.const_defined?('Puma::CLI')
    end

    generators do
      require_relative '../generators/monitorbit/install'
    end
  end
end
