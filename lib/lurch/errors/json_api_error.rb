module Lurch
  module Errors
    class JSONApiError < StandardError
      def initialize(document)
        @document = document
      end

      def message
        return document unless document.respond_to?(:errors)
        document.errors.map { |error| message_from_document_error(error) }.join(", ")
      end

    private

      attr_reader :document

      def message_from_document_error(error)
        "#{error.status}: #{error.detail}"
      end
    end
  end
end
