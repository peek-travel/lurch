module Lurch
  module Errors
    class RelationshipNotLoaded < StandardError
      def message
        "Relationship not loaded, try calling #fetch first."
      end
    end
  end
end
