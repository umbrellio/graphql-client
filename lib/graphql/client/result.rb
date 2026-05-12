# frozen_string_literal: true

module GraphQL
  module Client
    class Result
      def initialize(response)
        @client_response = response
        @response = response.empty? ? {} : Oj.load(response).deep_symbolize_keys
      end

      def data
        response[:data].each_value do |values|
          values.map do
            _1.transform_keys! { |key| key.to_s.underscore.to_sym }
          end
        end
      end

      def errors
        response[:errors]
      end

      def success?
        !error?
      end

      def error?
        response.key?(:errors)
      end

      def method_missing(method, *args, &block)
        if client_response.respond_to?(method)
          client_response.public_send(method, *args, &block)
        else
          super
        end
      end

      private

      attr_reader :response
      attr_reader :client_response

      def respond_to_missing?(method, include_private = false)
        client_response.respond_to?(method, include_private) || super
      end
    end
  end
end
