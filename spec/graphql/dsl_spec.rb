# frozen_string_literal: true

RSpec.describe GraphQL::DSL do
  describe 'query' do
    subject(:query) do
      GraphQL::DSL.query('test') do
        testField
      end
    end

    let(:expected_gql) do
      <<~GQL
        query test
        {
          testField
        }
      GQL
    end

    it 'creates a query' do
      expect(query.to_gql).to be_eql(expected_gql)
    end

    context 'when query has arguments' do
      subject(:query) do
        GraphQL::DSL.query('test') do
          testField({ key: 'value' })
        end
      end

      let(:expected_gql) do
        <<~GQL
          query test
          {
            testField(key: "value")
          }
        GQL
      end

      it 'creates a query with arguments' do
        expect(query.to_gql).to be_eql(expected_gql)
      end

      context 'when argument is a symbol' do
        subject(:query) do
          GraphQL::DSL.query('test') do
            testField(:value)
          end
        end

        it 'raises an error' do
          expect do
            query.to_gql
          end.to raise_error(GraphQL::DSL::Error, 'Allowed named arguments only')
        end
      end
    end

    context 'when query has multiple fields' do
      subject(:query) do
        GraphQL::DSL.query('test') do
          testField
          anotherField
        end
      end

      let(:expected_gql) do
        <<~GQL
          query test
          {
            testField
            anotherField
          }
        GQL
      end

      it 'creates a query with multiple fields' do
        expect(query.to_gql).to be_eql(expected_gql)
      end
    end

    context 'when query has nested fields' do
      subject(:query) do
        GraphQL::DSL.query('test') do
          testField do
            nestedField
          end
        end
      end

      let(:expected_gql) do
        <<~GQL
          query test
          {
            testField
            {
              nestedField
            }
          }
        GQL
      end

      it 'creates a query with nested fields' do
        expect(query.to_gql).to be_eql(expected_gql)
      end
    end
  end

  context 'when query has aliases' do
    subject(:query) do
      GraphQL::DSL.query('test') do
        testField __alias: 'test_field'
      end
    end

    let(:expected_gql) do
      <<~GQL
        query test
        {
          test_field: testField
        }
      GQL
    end

    it 'creates a query with aliases' do
      expect(query.to_gql).to be_eql(expected_gql)
    end
  end

  context 'when query has no fields' do
    subject(:query) do
      GraphQL::DSL.query('test')
    end

    it 'raises an error' do
      expect { query.to_gql }.to raise_error(GraphQL::DSL::Error, 'Block must be specified')
    end
  end
end
