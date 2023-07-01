module Rails
  module Htmx
    class Error < StandardError; end

    class Unsupported < Error; end

    module Controller
      extend ActiveSupport::Concern

      included do
        layout proc { |c| htmx_request? ? htmx_layout : nil }
        helper_method :htmx_request?

        rescue_from Rails::Htmx::Unsupported, with: :htmx_unsupported
      end

      # The templates for new generated Rails 7.0+ apps use 303 for redirects:
      # https://github.com/rails/rails/commit/5ed37b35d666b833a
      # https://github.com/rails/rails/commit/d6715c72c50255ccc
      #
      # We might be able to remove this method in the future.
      def redirect_to(url_options = {}, response_status = {})
        return_value = super

        # Return 303 to make sure a GET request will be used to display the redirect.
        # Ref: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/303
        self.status = 303 if htmx_request? && !request.get? && !request.post?

        return_value
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
