module Lurch
  class Relationship
    class HasMany < Relationship
      def initialize(store, relationship_key, document)
        @store = store
        @relationship_key = relationship_key
        @document = document
        @data = @document["data"].map { |resource_identifier| Resource.new(@store, resource_identifier["type"], resource_identifier["id"]) }
      end

      def inspect
        suffix = @data.first ? "[#{@data.first.type}]" : ""
        "#<#{self.class}#{suffix} size: #{@data.size}>"
      end
    end
  end
end
