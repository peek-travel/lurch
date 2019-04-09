module Lurch
  class Query
    def initialize(store, inflector)
      @store = store
      @inflector = inflector
      @filter = {}
      @include = []
      @fields = Hash.new { [] }
      @sort = []
      @page = {}
    end

    def filter(params)
      @filter.merge!(params)
      self
    end

    def include(*relationship_paths)
      @include += relationship_paths
      self
    end

    def fields(type, fields = nil)
      type, fields = [@type, type] if type.is_a?(Array) && fields.nil?
      @fields[type] += fields
      self
    end

    def sort(*sort_keys)
      @sort += sort_keys.map { |sort_key| sort_key.is_a?(Hash) ? sort_key : { sort_key => :asc } }
      self
    end

    def page(params)
      @page.merge!(params)
      self
    end

    def type(type)
      @type = inflector.decode_type(type)
      self
    end

    # def link(uri)
    #   # TODO: fail if type already set
    #   # TODO: set uri and merge in query params from provided uri if any
    #   self
    # end

    def all
      raise ArgumentError, "No type specified for query" if @type.nil?
      @store.load_from_url(uri_builder.resources_uri(@type, to_query))
    end

    def find(id)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Can't perform find for `nil`" if id.nil?
      @store.peek(@type, id) || @store.load_from_url(uri_builder.resource_uri(@type, id, to_query))
    end

    def save(changeset)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Type mismatch" if @type != inflector.decode_type(changeset.type)

      @store.save(changeset, to_query)
    end

    def insert(changeset)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Type mismatch" if @type != inflector.decode_type(changeset.type)

      @store.insert(changeset, to_query)
    end

    def delete(resource)
      raise ArgumentError, "No type specified for query" if @type.nil?
      raise ArgumentError, "Type mismatch" if @type != resource.type
      @store.delete(resource, to_query)
    end

    def inspect
      type = @type.nil? ? "" : "[#{@type}]"
      query = to_query
      query = query.empty? ? "" : " #{query.inspect}"
      "#<#{self.class}#{type}#{query}>"
    end

  private

    attr_reader :inflector

    def uri_builder
      @uri_builder ||= URIBuilder.new(inflector)
    end

    def to_query
      QueryBuilder.new(
        {
          filter: filter_query,
          include: include_query,
          fields: fields_query,
          sort: sort_query,
          page: page_query
        }.merge(other_uri_params)
      ).encode
    end

    def other_uri_params
      # TODO: existing non-standard uri query params from the provided uri (if any)
      {}
    end

    def filter_query
      inflector.encode_keys(@filter)
    end

    def include_query
      @include.map { |path| inflector.encode_key(path) }.compact.uniq.join(",")
    end

    def fields_query
      inflector.encode_types(@fields) do |fields|
        fields.map { |field| inflector.encode_key(field) }.compact.uniq.join(",")
      end
    end

    def sort_query
      @sort.flat_map(&:to_a).map { |(key, direction)| sort_key(key, direction) }.join(",")
    end

    def sort_key(key, direction)
      encoded_key = inflector.encode_key(key)
      case direction
      when :asc
        encoded_key
      when :desc
        "-#{encoded_key}"
      else
        raise ArgumentError, "Invalid sort direction #{direction}"
      end
    end

    def page_query
      @page
    end
  end
end
