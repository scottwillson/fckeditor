module Fckeditor
  
  PLUGIN_NAME = 'fckeditor'
  PLUGIN_PATH = "#{Rails.root}/vendor/plugins/#{PLUGIN_NAME}"
  PLUGIN_PUBLIC_PATH = "#{PLUGIN_PATH}/public"
  PLUGIN_CONTROLLER_PATH = "#{PLUGIN_PATH}/app/controllers"  
  PLUGIN_VIEWS_PATH = "#{PLUGIN_PATH}/app/views"  
  PLUGIN_HELPER_PATH = "#{PLUGIN_PATH}/app/helpers"
  
  class FckeditorRailtie < Rails::Railtie
    # Include hook code here
    require 'fckeditor'
    require 'fckeditor_version'
    require 'fckeditor_file_utils'

    FckeditorFileUtils.check_and_install

    # make plugin controller available to app
    Rails.configuration.autoload_paths += %W(#{Fckeditor::PLUGIN_CONTROLLER_PATH} #{Fckeditor::PLUGIN_HELPER_PATH})

    ActionView::Base.send(:include, Fckeditor::Helper)

    # require the controller
    require 'fckeditor_controller'
  end
end