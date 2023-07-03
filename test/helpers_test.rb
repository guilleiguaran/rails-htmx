require_relative "test_helper"
require "minitest/autorun"
require "rails-htmx/helpers"

class HelpersTest < Minitest::Test
  def setup
    @view_context = Object.new
    @view_context.extend(Rails::Htmx::Helpers)
  end

  def test_hx
    assert_equal({"hx-delete" => "/posts/1", "hx-swap" => "outerHTML", "hx-target" => "body", "hx-push-url" => "true"},
      @view_context.hx(delete: "/posts/1", swap: "outerHTML", target: "body", "push-url": "true"))
  end
end
