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
      Resource.new(self, stored_resource)
    end

    def fetch(type, id)
      normalized_type = Lurch.normalize_type(type)
      store[normalized_type][id]
    end

    def save
      # TODO
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

      stored_resources = store_resources(document)
      resources = stored_resources.map { |resource| Resource.new(self, resource) }

      document.data.is_a?(Array) ? resources : resources.first
    end

  private

    attr_reader :client, :store

    def push(resource)
      store[resource.type][resource.id] = resource
    end

    def store_resources(document)
      primary_stored_resources = Array(document.data).map do |data|
        push(StoredResource.new(self, data))
      end

      Array(document.included).each do |included_resource_data|
        push(StoredResource.new(self, included_resource_data))
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
