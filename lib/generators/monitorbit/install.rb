module Monitorbit
  class Install < Rails::Generators::Base
    def create_initializer_file
      append_to_file 'config/puma.rb', "activate_control_app\nplugin :yabeda"
    end
  end
end
