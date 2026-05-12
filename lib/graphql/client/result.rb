# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'

module GraphQL
  module Client
    class Result
      def initialize(response)
        @client_response = response
        @response = response.empty? ? {} : Oj.load(response).deep_symbolize_keys
      end

      def data
        return {} if response.empty?

        response[:data]
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
