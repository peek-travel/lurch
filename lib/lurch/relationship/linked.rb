module Lurch
  class Relationship
    class Linked < Relationship
      def initialize(store, relationship_key, document)
        @store = store
        @relationship_key = relationship_key
        @href = document["links"]["related"]
      end

      def fetch
        @data = @store.load_from_url(@href)
      end

      def inspect
        suffix = loaded? ? " \"loaded\"" : ""
        "#<#{self.class} href: #{@href.inspect}#{suffix}>"
      end
    end
  end
end
