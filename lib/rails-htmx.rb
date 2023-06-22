require "htmx"

module Rails
  module Htmx
    class Engine < ::Rails::Engine
      initializer "rails-htmx.add_controller" do
        ActiveSupport.on_load :action_controller do
          ActionController::Base.send :include, Rails::Htmx::Helpers
        end
      end
    end
  end
end
