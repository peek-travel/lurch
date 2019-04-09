# frozen_string_literal: true

module Lurch
  class Collection
    include Enumerable

    attr_reader :resources

    def initialize(resources, paginator)
      @resources = resources
      @paginator = paginator
    end

    def loaded?
      true
    end

    def fetch
      self
    end

    def each(&block)
      block_given? ? enum.each(&block) : enum
    end

    def each_page(&block)
      block_given? ? page_enum.each(&block) : page_enum
    end

    def size
      @paginator ? @paginator.record_count : @resources.size
    end

    def page_size
      @resources.size
    end

    def page_count
      @paginator&.page_count
    end

    def next_collection
      return @next_collection if defined?(@next_collection)

      @next_collection = @paginator ? @paginator.next_collection : nil
    end

    def prev_collection
      return @prev_collection if defined?(@prev_collection)

      @prev_collection = @paginator ? @paginator.prev_collection : nil
    end

    def first_collection
      return @first_collection if defined?(@first_collection)

      @first_collection = @paginator ? @paginator.first_collection : nil
    end

    def last_collection
      return @last_collection if defined?(@last_collection)

      @last_collection = @paginator ? @paginator.last_collection : nil
    end

    def next?
      @paginator ? @paginator.next? : false
    end

    def prev?
      @paginator ? @paginator.prev? : false
    end

    def first?
      @paginator ? @paginator.first? : false
    end

    def last?
      @paginator ? @paginator.last? : false
    end

    def inspect
      suffix = @resources.first ? "[#{Inflector.classify(@resources.first.type)}]" : ""
      inspection = size ? ["size: #{size}"] : []
      inspection << ["pages: #{page_count}"] if page_count
      "#<#{self.class}#{suffix} #{inspection.join(', ')}>"
    end

  private

    def enum
      Enumerator.new(-> { size }) do |yielder|
        @resources.each do |resource|
          yielder.yield(resource)
        end

        next_collection&.each do |resource|
          yielder.yield(resource)
        end
      end
    end

    def page_enum
      Enumerator.new(-> { page_count }) do |yielder|
        yielder.yield(@resources)

        next_collection&.each_page do |page|
          yielder.yield(page)
        end
      end
    end
  end
end
