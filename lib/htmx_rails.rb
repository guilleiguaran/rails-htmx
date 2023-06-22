require "htmx"

module HtmxRails
  class Engine < ::Rails::Engine
    initializer "htmx_rails.add_controller" do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, Htmx
      end
    end
  end
end
