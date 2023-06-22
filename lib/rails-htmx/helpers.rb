module Rails
  module Htmx
    class Error < StandardError; end

    class Unsupported < Error; end

    module Helpers
      extend ActiveSupport::Concern

      included do
        layout proc { |c| htmx_request? ? htmx_layout : nil }
        helper_method :htmx_request?

        rescue_from Rails::Htmx::Unsupported, with: :htmx_unsupported
      end

      protected

      def htmx_request?
        request.env["HTTP_HX_REQUEST"].present?
      end

      def htmx_layout
        false
      end

      def htmx_unsupported
        response.headers["HX-Redirect"] = request.url

        head :no_content
      end

      def prevent_htmx!
        raise Rails::Htmx::Unsupported if htmx_request?
      end
    end
  end
end