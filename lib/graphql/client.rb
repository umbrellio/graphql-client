# frozen_string_literal: true

require_relative 'client/version'
require_relative 'client/result'

require 'qonfig'
require 'oj'
require 'rest-client'
module GraphQL
  module Client
    class Error < StandardError; end

    class Custom
      class << self
        attr_reader :limiter_opts
        attr_reader :cache_opts

        def rate_limiter(**opts)
          @limiter_opts = {
            enabled: opts.fetch(:enabled, false),
            limit: opts.fetch(:limit, 100),
            period: opts.fetch(:period, 1.hour.to_i)
          }.freeze
        end

        def cache(**opts)
          @cache_opts = {
            enabled: opts.fetch(:enabled, false),
            ttl: opts.fetch(:ttl, 1.hour.to_i)
          }.freeze
        end
      end

      include Qonfig::Configurable

      configuration do
        setting :timeout
        setting :token
        setting :access_id
        setting :url
        setting :logger, Logger.new(STDOUT)

        validate 'timeout', :integer
        validate 'token', :string
        validate 'access_id', :string
        validate 'url', :string
      end

      def initialize(configurations = self.class.config)
        @configurations = configurations.tap(&:validate!)
      end

      def perform(query, variables = nil, options = {})
        request = build_request(query, variables, options)
        build_result(request.execute)
      rescue RestClient::ExceptionWithResponse, JSON::ParserError => error
        raise Error, "GraphQL client error (POST #{configurations.url}): #{error.message}"
      end

      private

      attr_reader :configurations

      def build_request(query, variables, options)
        RestClient::Request.new(
          method: :post,
          url: configurations.url,
          payload: { query: query, variables: variables }.to_json,
          timeout: options.fetch(:timeout, configurations.timeout),
          log: configurations.logger,
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
