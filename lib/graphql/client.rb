# frozen_string_literal: true

require_relative 'client/version'
require_relative 'client/result'

module GraphQL
  module Client
    class Error < StandardError; end

    class Custom
      include Qonfig::Configurable

      setting :timeout
      setting :token
      setting :access_id
      setting :url

      validate 'timeout', :integer
      validate 'token', :string
      validate 'access_id', :string
      validate 'url', :string

      def initialize(configurations = self.class.config)
        @configurations = configurations.tap(&:validate!)
      end

      def perform(query, variables = nil)
        request = build_request(query, variables)
        build_result(request.execute)
      rescue RestClient::ExceptionWithResponse, JSON::ParserError => error
        raise Error, "GraphQL client error (POST #{configurations.url}): #{error.message}"
      end

      private

      attr_reader :configurations

      def build_request(query, variables)
        RestClient::Request.new(
          method: :post,
          url: configurations.url,
          payload: { query: query, variables: variables }.to_json,
          timeout: configurations.timeout,
          headers: {
            'Authorization' => "Bearer #{configurations.access_id}:#{configurations.token}",
            'Content-Type' => 'application/json'
          }
        )
      end

      def build_result(response)
        GraphQL::Client::Result.new(response)
      end
    end
  end
end
