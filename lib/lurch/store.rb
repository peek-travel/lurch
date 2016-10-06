module Lurch
  class Store
    def initialize(url:, authorization: "", request_id: nil)
      @client = Client.new(url, authorization, request_id)
      @store = Hash.new { |hash, key| hash[key] = {} }
    end

    def find_all(type)
      normalized_type = Lurch.normalize_type(type)
      load_from_url(resources_url(normalized_type))
    end

    def find(type, id)
      normalized_type = Lurch.normalize_type(type)
      peek(normalized_type, id) || load_from_url(resource_url(normalized_type, id))
    end

    def peek(type, id)
      stored_resource = fetch(type, id)
      return nil if stored_resource.nil?
      Resource.new(self, stored_resource.type, stored_resource.id)
    end

    def fetch(type, id)
      normalized_type = Lurch.normalize_type(type)
      store[normalized_type][id]
    end

    def save(changeset)
      return insert(changeset) if changeset.id.nil?
      url = resource_url(changeset.type, changeset.id)

      document = client.patch(url, changeset.payload)
      process_document(document)
    end

    def insert(changeset)
      return save(changeset) unless changeset.id.nil?
      url = resources_url(changeset.type)

      document = client.post(url, changeset.payload)
      process_document(document)
    end

    def delete
      # TODO
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

    def load_from_url(url)
      document = client.get(url)
      process_document(document)
    end

  private

    attr_reader :client, :store

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

    def resources_url(type)
      "/#{Inflecto.dasherize(type.to_s)}"
    end

    def resource_url(type, id)
      "#{resources_url(type)}/#{id}"
    end
  end
end
