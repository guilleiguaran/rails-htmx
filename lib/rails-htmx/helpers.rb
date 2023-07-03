module Rails
  module Htmx
    module Helpers
      def htmx_attributes(attributes = {})
        return attributes if attributes.blank?
        attributes.transform_keys! { |key| "hx-#{key}" }
        attributes
      end
      alias_method :hx, :htmx_attributes
    end
  end
end
