# frozen_string_literal: true

module GraphQL
  module DSL
    # Base class for all GraphQL DSL nodes (i.e. queries, fields, etc.)
    class Node
      INDENT = '  '

      attr_reader :__name
      attr_reader :__nodes

      def initialize(name = nil, &block)
        @__name = name
        @__nodes = []

        instance_eval(&block) if block
      end

      # Build GraphQL string
      def to_gql(level = 0)
        raise NotImplementedError
      end
    end
  end
end
