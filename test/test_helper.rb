require "action_controller/railtie"

class TestApp < Rails::Application
  config.root = __dir__
  config.hosts << "example.org"
  config.session_store :cookie_store, key: "cookie_store_key"
  config.secret_key_base = "secret_key_base"

  config.logger = Logger.new($stdout)
  Rails.logger = config.logger

  routes.draw do
    get "/" => "test#index"
    get "/no_htmx" => "test#no_htmx"
  end
end
