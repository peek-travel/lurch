module Lurch
  class Inflector
    def initialize(inflection_mode, types_mode)
      @inflection_mode = inflection_mode
      @types_mode = types_mode
    end

    def self.classify(s)
      Inflecto.classify(s)
    end

    def self.decode_key(key)
      Inflecto.underscore(key.to_s).to_sym
    end

    def self.decode_type(type)
      Inflecto.pluralize(decode_key(type)).to_sym
    end

    def encode_key(key)
      case inflection_mode
      when :dasherize
        Inflecto.dasherize(key.to_s)
      when :underscore
        Inflecto.underscore(key.to_s)
      else
        raise ArgumentError, "Invalid inflection mode: #{inflection_mode}"
      end
    end

    def encode_keys(hash)
      hash.each_with_object({}) do |(key, value), acc|
        acc[encode_key(key)] = block_given? ? yield(value) : value
      end
    end

    def encode_type(type)
      key = encode_key(type)
      case types_mode
      when :pluralize
        Inflecto.pluralize(key)
      when :singularize
        Inflecto.singularize(key)
      else
        raise ArgumentError, "Invalid types mode: #{types_mode}"
      end
    end

    def encode_types(hash)
      hash.each_with_object({}) do |(key, value), acc|
        acc[encode_type(key)] = block_given? ? yield(value) : value
      end
    end

  private

    attr_reader :inflection_mode, :types_mode
  end
end
