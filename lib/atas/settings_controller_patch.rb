module Atas
  module SettingsControllerPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def get_project_services
        render :layout => false
      end 
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'settings_controller'
  SettingsController.send(:include, Atas::SettingsControllerPatch)
end
