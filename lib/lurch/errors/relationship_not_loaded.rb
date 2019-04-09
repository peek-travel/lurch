# frozen_string_literal: true

module Lurch
  module Errors
    class RelationshipNotLoaded < NotLoaded
      def message
        "Relationship (#{type}) not loaded, try calling #fetch first."
      end
    end
  end
end
