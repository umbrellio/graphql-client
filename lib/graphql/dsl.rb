# frozen_string_literal: true

require_relative 'dsl/node'
require_relative 'dsl/field'
require_relative 'dsl/query'

module GraphQL
  # Entry-point for GraphQL DSL
  module DSL
    # Create GraphQL query
    def query(name = nil, &block)
      Query.new(name, &block)
    end

    module_function :query
  end
end
