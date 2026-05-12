# frozen_string_literal: true

describe GraphQL::Client::Result do
  subject(:result) { described_class.new(response) }

  let(:response) do
    fake_response(
      url: 'http://example.com',
      method: 'get',
      to_hash: { 'Status' => ['200 OK'] }, code: '200', body: response_body
    )
  end
  let(:response_body) { '{"data": {"test": "test"}}' }

  describe '#data' do
    it 'returns the data' do
      expect(result.data).to eq({ test: 'test' })
    end

    context 'when response body is empty' do
      let(:response_body) { '{}' }

      it 'returns an empty hash' do
        expect(result.data).to eq({})
      end
    end
  end

  describe '#errors' do
    it 'returns the errors' do
      expect(result.errors).to eq(nil)
    end
  end

  describe '#success?' do
    it 'returns true if the response is successful' do
      expect(result.success?).to be(true)
    end
  end

  describe '#error?' do
    it 'returns false if the response is successful' do
      expect(result.error?).to be(false)
    end
  end

  describe '#body' do
    it 'returns the response body' do
      expect(result.body).to eq(response_body)
    end
  end

  describe '#code' do
    it 'returns the response code' do
      expect(result.code).to eq(200)
    end
  end

  describe '#headers' do
    it 'returns the response headers' do
      expect(result.headers).to eq({ status: '200 OK' })
    end
  end

  describe '#url' do
    it 'raises an error' do
      expect do
        result.url
      end.to raise_error(NoMethodError, "undefined method 'url' for an instance of GraphQL::Client::Result")
    end
  end
end
