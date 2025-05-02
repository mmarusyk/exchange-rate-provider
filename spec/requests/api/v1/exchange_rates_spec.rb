require 'swagger_helper'

RSpec.describe '/api/v1/exchange_rates' do
  path '/api/v1/exchange_rates' do
    get 'Lists exchange rates' do
      tags 'Exchange Rates'
      description 'Retrieves exchange rates based on source currency'
      produces 'application/json'

      parameter name: :source_currency, in: :query, required: true,
                schema: { pattern: '^[A-Z]{3}$', default: CZK_CURRENCY }
      parameter name: :date, in: :query, required: false, schema: { type: :string, format: 'date' }

      parameter name: :'target_currency[]', in: :query, required: false,
                schema: {
                  type: :array,
                  items: { type: :string, pattern: '^[A-Z]{3}$' }
                }

      let(:source_currency) { CZK_CURRENCY }

      after do |example|
        example.metadata[:response][:content] = {
          'application/json' => {
            example: JSON.parse(response.body, symbolize_names: true)
          }
        }
      end

      context 'with basic parameters', vcr: { cassette_name: 'cnbapi/exrates/daily/ok' } do
        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to include('source_currency', 'rates')
            expect(data['rates'].first[1]).to include('rate', 'amount')
          end
        end
      end

      context 'with target currency filter', vcr: { cassette_name: 'cnbapi/exrates/daily/ok' } do
        let(:'target_currency[]') { %w[EUR USD] }

        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['rates'].keys).to match_array(%w[EUR USD])
          end
        end
      end

      context 'with date parameter', vcr: { cassette_name: 'cnbapi/exrates/daily/with_date/ok' } do
        let(:date) { '2025-03-05' }

        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_present
          end
        end
      end

      context 'with unsupported source currency' do
        let(:source_currency) { 'UAH' }

        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)

            expect(data).to be_empty
          end
        end
      end

      context 'with invalid source currency format' do
        let(:source_currency) { 'invalid' }

        response('422', 'Unprocessable Content') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('source_currency')
            expect(data['errors']['source_currency']).to include('is in invalid format')
          end
        end
      end

      context 'with invalid target currency format' do
        let(:'target_currency[]') { ['invalid'] }

        response('422', 'Unprocessable Content') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('target_currency')
          end
        end
      end

      context 'with invalid date format' do
        let(:date) { 'invalid-date' }

        response('422', 'Unprocessable Content') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('date')
          end
        end
      end

      context 'when external server returns an error', vcr: { cassette_name: 'cnbapi/exrates/daily/failed' } do
        let(:date) { '2025-03-05' }

        response('422', 'Unprocessable Content') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('base')
          end
        end
      end
    end
  end
end
