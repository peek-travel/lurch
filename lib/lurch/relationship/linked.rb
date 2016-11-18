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

      # def filter(*args)
      #   @store.query.link(@href).filter(*args)
      # end
      #
      # def include(*args)
      #   @store.query.link(@href).include(*args)
      # end
      #
      # def fields(*args)
      #   @store.query.link(@href).fields(*args)
      # end
      #
      # def sort(*args)
      #   @store.query.link(@href).sort(*args)
      # end
      #
      # def page(*args)
      #   @store.query.link(@href).page(*args)
      # end

      def inspect
        suffix = loaded? ? " \"loaded\"" : ""
        "#<#{self.class} href: #{@href.inspect}#{suffix}>"
      end
    end
  end
end
