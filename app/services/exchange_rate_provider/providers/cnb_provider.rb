module ExchangeRateProvider
  module Providers
    class CnbProvider < BaseProvider
      BASE_URL = 'https://api.cnb.cz/cnbapi/exrates/daily'.freeze
      EXPIRES_IN = 1.hour.freeze

      def call(date: nil)
        Rails.cache.fetch(cache_key(date), expires_in: EXPIRES_IN) do
          response = make_request(date: date)

          parse_response(response)
        end
      end

      private

      def make_request(date: nil)
        params = {}
        params[:date] = date if date

        Faraday.get(BASE_URL, params)
      end

      def parse_response(response)
        raise RequestError, "API request failed with status #{response.status}" unless response.status.eql?(200)

        data = Oj.load(response.body)

        build_exchange_rates(data)
      end

      def build_exchange_rates(data)
        data['rates'].map do |rate_data|
          ExchangeRate.new(
            source_currency: CZK_CURRENCY,
            target_currency: rate_data['currencyCode'],
            amount: rate_data['amount'].to_f,
            rate: rate_data['rate'].to_f
          )
        end
      end

      def cache_key(date)
        ['exchange_rates', 'cnb', CZK_CURRENCY, date].join('_')
      end
    end
  end

  class RequestError < StandardError; end
end
