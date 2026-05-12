# frozen_string_literal: true

RSpec.describe GraphQL::Client do
  it "has a version number" do
    expect(GraphQL::Client::VERSION).not_to be_nil
  end
end
