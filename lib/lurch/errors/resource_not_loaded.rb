module Lurch
  module Errors
    class ResourceNotLoaded < StandardError
      def message
        "Resource not loaded, try calling #fetch first."
      end
    end
  end
end
