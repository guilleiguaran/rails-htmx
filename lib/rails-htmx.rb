require "rails-htmx/controller"

module Rails
  module Htmx
    class Engine < ::Rails::Engine
      initializer "rails-htmx.add_controller" do
        ActiveSupport.on_load :action_controller do
          ActionController::Base.send :include, Rails::Htmx::Controller
        end
      end
    end
  end
end
