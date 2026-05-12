# frozen_string_literal: true

require_relative 'error'
require_relative 'mixins/fields'

module GraphQL
  module DSL
    # Field node in GraphQL DSL
    class Field < Node
      include Mixins::Fields

      attr_reader :__arguments
      attr_reader :__alias

      def initialize(name, arguments: {}, &block)
        unless arguments.is_a?(Hash)
          raise GraphQL::DSL::Error.new 'Allowed named arguments only', {
            field_name: name,
            arguments: arguments
          }
        end

        super(name, &block)

        @__arguments = arguments
        @__alias = arguments.delete(:__alias)
      end

      # Build GraphQL string
      def to_gql(level = 0) # rubocop:disable Metrics/AbcSize
        result = []

        field_name = __alias ? "#{__alias}: #{__name}" : __name.to_s
        field_arguments = __arguments.empty? ? '' : __arguments_to_s(__arguments, initial: true)

        result << ((INDENT * level) + field_name + field_arguments)
        unless __nodes.empty?
          result << "#{INDENT * level}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{INDENT * level}}"
        end

        result.compact.join("\n")
      end

      private

      def __arguments_to_s(arguments, initial: false)
        case arguments
        when Hash
          __arguments_to_hash(arguments, initial: initial)
        when Array
          __arguments_to_array(arguments)
        when String
          "\"#{arguments}\""
        when Symbol
          arguments.to_s
        when NilClass
          'null'
        else
          arguments.to_s
        end
      end

      def __arguments_to_hash(arguments, initial: false)
        result = arguments.map do |name, value|
          "#{name}: #{__arguments_to_s(value)}"
        end.join(', ')

        if initial
          "(#{result})"
        else
          "{#{result}}"
        end
      end

      def __arguments_to_array(arguments)
        "[#{arguments.map { |param| __arguments_to_s(param) }.join(', ')}]"
      end
    end
  end
end
