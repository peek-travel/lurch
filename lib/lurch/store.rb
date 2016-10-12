module Lurch
  class Store
    def initialize(url:, authorization: "", request_id: nil)
      @client = Client.new(url, authorization, request_id)
      @store = Hash.new { |hash, key| hash[key] = {} }
    end

    def from(type)
      query.from(type)
    end

    def peek(type, id)
      stored_resource = resource_from_store(type, id)
      return nil if stored_resource.nil?
      Resource.new(self, stored_resource.type, stored_resource.id)
    end

    def save(changeset)
      return insert(changeset) if changeset.id.nil?
      url = URI.resource_uri(changeset.type, changeset.id)

      document = client.patch(url, changeset.payload)
      process_document(document)
    end

    def insert(changeset)
      return save(changeset) unless changeset.id.nil?
      url = URI.resources_uri(changeset.type)

      document = client.post(url, changeset.payload)
      process_document(document)
    end

    def delete(resource)
      url = URI.resource_uri(resource.type, resource.id)
      client.delete(url)

      remove(resource)
      true
    end

    def add_relationship
      # TODO
    end

    def delete_relationship
      # TODO
    end

    def update_relationship
      # TODO
    end

    # @private
    def load_from_url(url)
      document = client.get(url)
      process_document(document)
    end

    # @private
    def resource_from_store(type, id)
      normalized_type = Lurch.normalize_type(type)
      store[normalized_type][id]
    end

  private

    attr_reader :client, :store

    def query
      Query.new(self)
    end

    def process_document(document)
      stored_resources = store_resources(document)
      resources = stored_resources.map do |stored_resource|
        Resource.new(self, stored_resource.type, stored_resource.id)
      end

      document["data"].is_a?(Array) ? resources : resources.first
    end

    def push(resource)
      store[resource.type][resource.id] = resource
    end

    def remove(resource)
      store[resource.type].delete(resource.id)
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
  end
end
