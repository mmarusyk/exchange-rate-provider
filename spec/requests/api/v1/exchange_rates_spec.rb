require 'swagger_helper'

RSpec.describe '/api/v1/exchange_rates' do
  path '/api/v1/exchange_rates' do
    get 'Lists exchange rates' do
      tags 'Exchange Rates'
      description 'Retrieves exchange rates based on source currency'
      produces 'application/json'

      parameter name: :source_currency, in: :query, type: :string, required: true,
                schema: { type: :string, pattern: '^[A-Z]{3}$' }

      parameter name: :'target_currency[]', in: :query, required: false,
                schema: {
                  type: :array,
                  items: { type: :string, pattern: '^[A-Z]{3}$' }
                }

      parameter name: :date, in: :query, type: :string, required: false,
                schema: { type: :string, format: 'date' }

      parameter name: :lang, in: :query, type: :string, required: false,
                schema: { type: :string, enum: %w[CZ EN] }

      let(:source_currency) { 'CZK' }

      after do |example|
        example.metadata[:response][:content] = {
          'application/json' => {
            example: JSON.parse(response.body, symbolize_names: true)
          }
        }
      end

      context 'with basic parameters', vcr: { cassette_name: 'cnbapi/exrates/daily/cz/ok' } do
        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_an(Array)
            expect(data.first).to include('source_currency', 'target_currency', 'rate')
          end
        end
      end

      context 'with target currency filter', vcr: { cassette_name: 'cnbapi/exrates/daily/cz/ok' } do
        let(:'target_currency[]') { %w[EUR USD] }

        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            target_currencies = data.map { |r| r['target_currency'] }
            expect(target_currencies).to match_array(%w[EUR USD])
          end
        end
      end

      context 'with date parameter', vcr: { cassette_name: 'cnbapi/exrates/daily/with_date/ok' } do
        let(:date) { '2025-03-05' }

        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.first['date']).to eq('2025-03-05')
          end
        end
      end

      context 'with language parameter', vcr: { cassette_name: 'cnbapi/exrates/daily/en/ok' } do
        let(:lang) { 'EN' }

        response('200', 'OK') do
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.first).to have_key('country')
            expect(data.first).to have_key('currency_name')
          end
        end
      end

      response('422', 'Invalid request parameters') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   },
                   example: {
                     source_currency: ['must be a valid 3-letter currency code']
                   }
                 }
               }

        context 'with invalid source currency format' do
          let(:source_currency) { 'invalid' }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('source_currency')
            expect(data['errors']['source_currency']).to include('must be a valid 3-letter currency code')
          end
        end

        context 'with unsupported source currency' do
          let(:source_currency) { 'MMM' }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('source_currency')
            expect(data['errors']['source_currency']).to include('No provider available for MMM')
          end
        end

        context 'with invalid target currency format' do
          let(:source_currency) { 'CZK' }
          let(:'target_currency[]') { ['invalid'] }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('target_currency')
          end
        end

        context 'with invalid date format' do
          let(:source_currency) { 'CZK' }
          let(:date) { 'invalid-date' }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['errors']).to have_key('date')
          end
        end
      end
    end
  end
end
