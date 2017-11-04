module Lurch
  module Errors
    class JSONApiError < StandardError
      attr_reader :status

      def initialize(document, status)
        @document = document
        @status = status
      end

      def message
        return "#{@status}: #{@document}" unless errors_document?

        "#{@status}: #{errors_string}"
      end

      def errors
        return [] unless errors_document?

        @document["errors"].map { |error| Lurch::Error.new(error) }
      end

    private

      def errors_document?
        @document.is_a?(Hash) && @document["errors"].is_a?(Array)
      end

      def errors_string
        @document["errors"].map { |error| error["detail"] }.join(", ")
      end
    end
  end
end
