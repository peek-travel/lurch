module Lurch
  class Store
    def initialize(url, options = {})
      @config = StoreConfiguration.new(options)
      @client = Client.new(url, @config)
      @store = Hash.new { |hash, key| hash[key] = {} }
    end

    def from(type)
      query.type(type)
    end
    alias to from

    def peek(type, id)
      stored_resource = resource_from_store(type, id.to_s)
      return nil if stored_resource.nil?
      Resource.new(self, stored_resource.type, stored_resource.id)
    end

    def save(changeset, query = {})
      return insert(changeset) if changeset.id.nil?
      url = uri_builder.resource_uri(changeset.type, changeset.id, query)

      document = @client.patch(url, payload_builder.build(changeset))
      process_document(document)
    rescue Errors::JSONApiError => err
      changeset.errors = err.errors
      raise err
    end

    def insert(changeset, query = {})
      return save(changeset) unless changeset.id.nil?
      url = uri_builder.resources_uri(changeset.type, query)

      document = @client.post(url, payload_builder.build(changeset))
      process_document(document)
    rescue Errors::JSONApiError => err
      changeset.errors = err.errors
      raise err
    end

    def delete(resource, query = {})
      url = uri_builder.resource_uri(resource.type, resource.id, query)
      @client.delete(url)

      remove(resource)
      true
    end

    # add resource(s) to a has many relationship
    def add_related(resource, relationship_key, related_resources)
      modify_relationship(:post, resource, relationship_key, related_resources)
    end

    # remove resource(s) from a has many relationship
    def remove_related(resource, relationship_key, related_resources)
      modify_relationship(:delete, resource, relationship_key, related_resources)
    end

    # replace resource(s) for a has many or has one relationship
    def update_related(resource, relationship_key, related_resources)
      modify_relationship(:patch, resource, relationship_key, related_resources)
    end

    # @private
    def load_from_url(url)
      document = @client.get(url)
      process_document(document)
    end

    # @private
    def resource_from_store(type, id)
      normalized_type = Inflector.decode_type(type)
      @store[normalized_type][id]
    end

    # @private
    def query
      Query.new(self, inflector)
    end

  private

    def inflector
      @inflector ||= Inflector.new(@config.inflection_mode, @config.types_mode)
    end

    def uri_builder
      @uri_builder ||= URIBuilder.new(inflector)
    end

    def payload_builder
      @payload_builder ||= PayloadBuilder.new(inflector)
    end

    def process_document(document)
      stored_resources = store_resources(document)
      resources = stored_resources.map do |stored_resource|
        Resource.new(self, stored_resource.type, stored_resource.id)
      end

      if document["data"].is_a?(Array)
        paginator = pagination_links?(document) ? Paginator.new(self, document, inflector, @config) : nil
        Collection.new(resources, paginator)
      else
        resources.first
      end
    end

    def push(stored_resource)
      @store[stored_resource.type][stored_resource.id] = stored_resource
    end

    def remove(resource)
      @store[resource.type].delete(resource.id)
    end

    def store_resources(document)
      primary_data = Lurch.to_a(document["data"])

      primary_stored_resources = primary_data.map do |resource_object|
        push(StoredResource.new(self, resource_object))
      end

      Lurch.to_a(document["included"]).each do |resource_object|
        push(StoredResource.new(self, resource_object))
      end

      primary_stored_resources
    end

    def modify_relationship(method, resource, relationship_key, related_resources)
      url = uri_builder.relationship_uri(resource.type, resource.id, relationship_key)
      payload = payload_builder.build(related_resources, true)
      @client.send(method, url, payload)
      true
    end

    def pagination_links?(document)
      links = document["links"]
      links && (
        links["first"] ||
        links["last"] ||
        links["next"] ||
        links["prev"]
      )
    end
  end
end
