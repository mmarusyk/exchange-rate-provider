require 'rails_helper'

RSpec.describe ExchangeRateProvider::Providers::CnbProvider do
  describe '#call' do
    subject(:cnb_provider) { described_class.new }

    let(:rates) { cnb_provider.call }
    let(:first_rate) { rates.first }

    context 'when fetching exchange rates', vcr: { cassette_name: 'cnbapi/exrates/daily/cz/ok' } do
      it 'returns an array of rates' do
        expect(rates).to be_an(Array)
      end

      it 'returns non-empty collection' do
        expect(rates).not_to be_empty
      end

      it 'returns ExchangeRate objects' do
        expect(first_rate).to be_a(ExchangeRateProvider::ExchangeRate)
      end

      it 'uses CZK as source currency' do
        expect(first_rate.source_currency).to eq('CZK')
      end

      it 'has valid target currency format' do
        expect(first_rate.target_currency).to match(/\A[A-Z]{3}\z/)
      end

      it 'includes rate as a float value' do
        expect(first_rate.rate).to be_a(Float)
      end

      it 'includes amount as a float value' do
        expect(first_rate.amount).to be_a(Float)
      end
    end

    context 'with date parameter', vcr: { cassette_name: 'cnbapi/exrates/daily/with_date/ok' } do
      let(:specific_date) { '2025-03-05' }
      let(:dated_rates) { cnb_provider.call(date: specific_date) }

      it 'returns rates with the specified date' do
        expect(dated_rates.first.date).to eq(specific_date)
      end
    end

    context 'with language parameter' do
      let(:rates_cz) do
        VCR.use_cassette('cnbapi/exrates/daily/cz/ok') { cnb_provider.call(lang: 'CZ') }
      end

      let(:rates_en) do
        VCR.use_cassette('cnbapi/exrates/daily/en/ok') { cnb_provider.call(lang: 'EN') }
      end

      it 'returns different country names based on language' do
        expect(rates_cz.first.country).not_to eq(rates_en.first.country)
      end
    end
  end
end
