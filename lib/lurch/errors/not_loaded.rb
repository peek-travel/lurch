# frozen_string_literal: true

module Lurch
  module Errors
    class NotLoaded < StandardError
      def initialize(type)
        @type = type
      end

    private

      attr_reader :type
    end
  end
end
