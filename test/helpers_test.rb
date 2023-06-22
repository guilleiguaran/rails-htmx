require_relative "test_helper"
require "rack/test"
require "minitest/autorun"
require "rails-htmx/helpers"

class TestController < ActionController::Base
  include Rails.application.routes.url_helpers
  include Rails::Htmx::Helpers

  def index
    render plain: "htmlx_request?: #{htmx_request?}"
  end

  def no_htmx
    prevent_htmx!

    render plain: "No Htmx"
  end
end

class HelpersTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def test_request_without_header
    get "/"
    assert last_response.ok?
    assert last_response.body.include?("htmlx_request?: false")
  end

  def test_htmx_request_with_header
    header "HX-Request", "true"
    get "/"
    assert last_response.ok?
    assert last_response.body.include?("htmlx_request?: true")
  end

  def test_htmx_request_with_header_and_prevent_htmx
    header "HX-Request", "true"
    get "/no_htmx"

    assert_equal 204, last_response.status
    assert_equal "http://example.org/no_htmx", last_response.headers["HX-Redirect"]
  end
end
