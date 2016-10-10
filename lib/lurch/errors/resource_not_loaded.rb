module Lurch
  module Errors
    class ResourceNotLoaded < NotLoaded
      def message
        "Resource (#{type}) not loaded, try calling #fetch first."
      end
    end
  end
end
