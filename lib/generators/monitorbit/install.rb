# frozen_string_literal: true

module Monitorbit
  class Install < Rails::Generators::Base
    def create_initializer_file
      append_to_file 'config/puma.rb', "activate_control_app\nplugin :yabeda"
    end

    def add_middleware
      gsub_file(
        'config.ru',
        'run Rails.application', "use Monitorbit::ErrorsNotificationsLayer\n\nrun Rails.application"
      )
    end
  end
end
