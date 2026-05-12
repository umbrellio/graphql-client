# frozen_string_literal: true

require 'graphql/client'
require 'graphql/dsl'

require 'pry'

SpecSupport = Module.new

Dir[File.join(__dir__, 'support/**/**/*.rb')].each { require(_1) }

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expose_dsl_globally = true
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include SpecSupport::ResponseHelpers
end
