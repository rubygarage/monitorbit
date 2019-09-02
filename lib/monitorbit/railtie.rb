require 'yabeda/rails'
require 'yabeda/sidekiq'
require 'yabeda/prometheus'
require 'yabeda/puma/plugin'
require 'prometheus/client'

module Monitorbit
  class Railtie < Rails::Railtie
    generators do
      require_relative '../generators/monitorbit/install'
    end
  end
end
