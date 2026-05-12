# frozen_string_literal: true

module GraphQL
  module DSL
    module Mixins
      # Mixin module for nodes with fields i.e. queries, fields
      module Fields
        # Create GraphQL field
        #
        # It can help to avoid name collisions in some cases
        # i.e. `__field("id")` because BasicObject#id exists
        def __field(name, arguments = {}, &block)
          @__nodes << Field.new(name, arguments: arguments, &block)
        end

        private

        def respond_to_missing?(_method_name, _include_private = false)
          true
        end

        # Create GraphQL field use meta programming
        #
        # Example:
        #
        # filed1 {
        #   subfiled1
        #   subfield2
        # }
        def method_missing(name, *args, &block)
          args = args.empty? ? {} : args[0]
          __field(name.to_s, args, &block)
        end
      end
    end
  end
end
