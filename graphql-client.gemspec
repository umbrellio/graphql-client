# frozen_string_literal: true

require_relative 'lib/graphql/client/version'

Gem::Specification.new do |spec|
  spec.name = 'graphql-client'
  spec.version = GraphQL::Client::VERSION
  spec.authors = ['Aleksey Sol']
  spec.email = ['aleksey.sol@cadolabs.io']

  spec.summary = 'A Ruby client for GraphQL APIs.'
  spec.description = 'A Ruby client for GraphQL APIs with a block-based DSL for building queries.'
  spec.homepage = 'https://github.com/umbrellio/graphql-client'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.4.5'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readline.split("\x0").reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ spec/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'qonfig', '>= 0.30.0'
  spec.add_dependency 'rest-client', '>= 2.1.0'

  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rake', '>= 13'
  spec.add_development_dependency 'armitage-rubocop', '~> 1.59'
  spec.add_development_dependency 'pry', '~> 0.15'
end
