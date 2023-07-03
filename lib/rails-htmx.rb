require "rails-htmx/controller"
require "rails-htmx/helpers"

module Rails
  module Htmx
    class Engine < ::Rails::Engine
      initializer "rails-htmx.add_controller" do
        ActiveSupport.on_load :action_controller do
          ActionController::Base.send :include, Rails::Htmx::Controller
        end
      end

      initializer "rails-htmx.add_helpers" do
        ActiveSupport.on_load :action_view do
          ActionView::Base.send :include, Rails::Htmx::Helpers
        end
      end
    end
  end
end
