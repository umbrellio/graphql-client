# frozen_string_literal: true

require_relative 'mixins/fields'

module GraphQL
  module DSL
    # Query node in GraphQL DSL
    class Query < Node
      include Mixins::Fields

      def initialize(name = nil, &block)
        raise Error, 'Block must be specified' unless block

        super
      end

      # Build GraphQL string
      def to_gql(level = 0)
        raise Error, 'Query must have nodes' if __nodes.empty?

        result = []

        result << (__name ? "#{INDENT * level}query #{__name}" : nil)
        result << "#{INDENT * level}{"
        result += __nodes.map { |node| node.to_gql(level + 1) }
        result << "#{INDENT * level}}"
        result << ''

        result.compact.join("\n")
      end
    end
  end
end
