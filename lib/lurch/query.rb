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
      @store.load_from_url(resources_url)
    end

    def find(id)
      @store.peek(@type, id) || @store.load_from_url(resource_url(id))
    end

    def to_params
      ParamBuilder.new(
        filter: @filter,
        sort: @sort,
        page: @page,
        include: @include,
        fields: @fields
      ).encode
    end

  private

    def resources_url
      uri = URI.parse("/#{Inflecto.dasherize(@type.to_s)}")
      params = to_params
      uri.query = params unless params.empty?
      uri.to_s
    end

    def resource_url(id)
      uri = URI.parse("#{resources_url}/#{id}")
      params = to_params
      uri.query = params unless params.empty?
      uri.to_s
    end
  end
end
