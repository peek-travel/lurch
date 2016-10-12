module Lurch
  class Query
    def initialize(store)
      @store = store
      @filter = {}
      @sort = {}
      @page = {}
      @include = {}
      @fields = {}
    end

    def filter(params)
      @filter = @filter.merge(params)
      self
    end

    def from(type)
      @type = Lurch.normalize_type(type)
      self
    end

    def all
      @store.load_from_url(URI.resources_uri(@type, to_query))
    end

    def find(id)
      @store.peek(@type, id) || @store.load_from_url(URI.resource_uri(@type, id, to_query))
    end

  private

    def to_query
      QueryBuilder.new(
        filter: @filter,
        sort: @sort,
        page: @page,
        include: @include,
        fields: @fields
      ).encode
    end
  end
end
