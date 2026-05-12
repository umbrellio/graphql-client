# frozen_string_literal: true

module GraphQL
  module DSL
    # GraphQL DSL error
    class Error < StandardError
      # Additional arguments associates with error
      attr_reader :arguments

      def initialize(msg = nil, arguments = {})
        super(msg)
        @arguments = arguments
      end
    end
  end
end
