module Lurch
  class QueryBuilder
    def initialize(params)
      @params = Hash(params)
    end

    def encode
      encode_value(@params)
    end

  private

    def encode_value(value, key = nil)
      case value
      when Hash  then value.map { |k, v| encode_value(v, append_key(key, k)) }.reject(&:empty?).join("&")
      when Array then value.map { |v| encode_value(v, "#{key}[]") }.reject(&:empty?).join("&")
      else
        value.to_s.empty? ? "" : "#{key}=#{CGI.escape(value.to_s)}"
      end
    end

    def append_key(root_key, key)
      root_key.nil? ? key : "#{root_key}[#{key}]"
    end
  end
end
