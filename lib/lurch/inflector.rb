module Lurch
  class Inflector
    def initialize(inflection_mode, types_mode)
      define_encode_key(inflection_mode)
      define_encode_type(types_mode)
    end

    def self.classify(str)
      Inflecto.classify(str)
    end

    def self.decode_key(key)
      Inflecto.underscore(key.to_s).to_sym
    end

    def self.decode_type(type)
      Inflecto.pluralize(decode_key(type)).to_sym
    end

    def define_encode_key(inflection_mode)
      case inflection_mode
      when :dasherize
        define_singleton_method(:encode_key) { |key| Inflecto.dasherize(key.to_s) }
      when :underscore
        define_singleton_method(:encode_key) { |key| Inflecto.underscore(key.to_s) }
      else
        raise ArgumentError, "Invalid inflection mode: #{inflection_mode}"
      end
    end

    def define_encode_type(types_mode)
      case types_mode
      when :pluralize
        define_singleton_method(:encode_type) do |type|
          key = encode_key(type)
          Inflecto.pluralize(key)
        end
      when :singularize
        define_singleton_method(:encode_type) do |type|
          key = encode_key(type)
          Inflecto.singularize(key)
        end
      else
        raise ArgumentError, "Invalid types mode: #{types_mode}"
      end
    end

    def encode_keys(hash)
      hash.each_with_object({}) do |(key, value), acc|
        acc[encode_key(key)] = block_given? ? yield(value) : value
      end
    end

    def encode_types(hash)
      hash.each_with_object({}) do |(key, value), acc|
        acc[encode_type(key)] = block_given? ? yield(value) : value
      end
    end
  end
end
