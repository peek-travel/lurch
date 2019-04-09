# frozen_string_literal: true

module Lurch
  class Relationship
    class HasOne < Relationship
      def initialize(store, relationship_key, document)
        @store = store
        @relationship_key = relationship_key
        if document["data"].nil?
          @data = nil
        else
          @type = Inflector.decode_type(document["data"]["type"])
          @id = document["data"]["id"]
          @data = Resource.new(@store, @type, @id)
        end
      end

      def inspect
        @data.nil? ? "#<#{self.class} nil>" : "#<#{self.class}[#{Inflector.classify(@type)}] id: #{@id.inspect}>"
      end
    end
  end
end
