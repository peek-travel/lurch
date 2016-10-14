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

    def type(type)
      @type = Lurch.normalize_type(type)
      self
    end

    def all
      raise ArgumentError, "No type specified for query" if @type.nil?
      @store.load_from_url(URI.resources_uri(@type, to_query))
    end

    def find(id)
      raise ArgumentError, "No type specified for query" if @type.nil?
      @store.peek(@type, id) || @store.load_from_url(URI.resource_uri(@type, id, to_query))
    end

    def save(changeset)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Type mismatch" if @type != changeset.type
      @store.save(changeset, to_query)
    end

    def insert(changeset)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Type mismatch" if @type != changeset.type
      @store.insert(changeset, to_query)
    end

    def delete(resource)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Type mismatch" if @type != resource.type
      @store.delete(resource, to_query)
    end

    def inspect
      type = @type.nil? ? "" : "[#{Inflecto.classify(@type)}]"
      query = to_query
      query = query.empty? ? "" : " #{query.inspect}"
      "#<#{self.class}#{type}#{query}>"
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
