require_relative "test_helper"
require "rack/test"
require "minitest/autorun"
require "rails-htmx/controller"

class TestController < ActionController::Base
  include Rails.application.routes.url_helpers
  include Rails::Htmx::Controller

  def index
    render plain: "htmlx_request?: #{htmx_request?}"
  end

  def redirect
    redirect_to root_url
  end

  def no_htmx
    prevent_htmx!

    render plain: "No Htmx"
  end
end

class ControllerTest < Minitest::Test
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

  def test_redirect_with_get
    header "HX-Request", "true"
    get "/redirect"

    assert last_response.redirect?
    assert_equal 302, last_response.status
    assert_equal "http://example.org/", last_response.headers["Location"]
  end

  def test_redirect_with_post
    header "HX-Request", "true"
    post "/redirect"

    assert last_response.redirect?
    assert_equal 302, last_response.status
    assert_equal "http://example.org/", last_response.headers["Location"]
  end

  def test_redirect_with_put
    header "HX-Request", "true"
    put "/redirect"

    assert last_response.redirect?
    assert_equal 303, last_response.status
    assert_equal "http://example.org/", last_response.headers["Location"]
  end

  def test_redirect_with_patch
    header "HX-Request", "true"
    patch "/redirect"

    assert last_response.redirect?
    assert_equal 303, last_response.status
    assert_equal "http://example.org/", last_response.headers["Location"]
  end

  def test_redirect_with_delete
    header "HX-Request", "true"
    delete "/redirect"

    assert_equal 303, last_response.status
    assert_equal "http://example.org/", last_response.headers["Location"]
  end
end
