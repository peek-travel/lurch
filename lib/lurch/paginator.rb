module Lurch
  class Paginator
    def initialize(store, document, inflector, config)
      @store = store
      @links = document["links"]
      @meta = document["meta"]
      @config = config
      @inflector = inflector
    end

    def record_count
      key = @inflector.encode_key(@config.pagination_record_count_key)
      @meta[key]
    end

    def page_count
      key = @inflector.encode_key(@config.pagination_page_count_key)
      @meta[key]
    end

    def next_collection
      next_link && @store.load_from_url(next_link)
    end

    def prev_collection
      prev_link && @store.load_from_url(prev_link)
    end

    def first_collection
      first_link && @store.load_from_url(first_link)
    end

    def last_collection
      last_link && @store.load_from_url(last_link)
    end

    def next?
      !!next_link
    end

    def prev?
      !!prev_link
    end

    def first?
      !!first_link
    end

    def last?
      !!last_link
    end

  private

    def next_link
      @links["next"]
    end

    def prev_link
      @links["prev"]
    end

    def first_link
      @links["first"]
    end

    def last_link
      @links["last"]
    end
  end
end
