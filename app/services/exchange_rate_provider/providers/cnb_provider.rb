module ExchangeRateProvider
  module Providers
    class CnbProvider < ProviderInterface
      BASE_URL = 'https://api.cnb.cz/cnbapi/exrates/daily'.freeze
      SOURCE_CURRENCY = 'CZK'.freeze

      def call(date: nil, lang: nil)
        response = make_request(date: date, lang: lang)

        parse_response(response)
      end

      private

      def make_request(date: nil, lang: nil)
        params = {}
        params[:date] = date if date
        params[:lang] = lang if lang

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
            date: rate_data['validFor'],
            source_currency: SOURCE_CURRENCY,
            target_currency: rate_data['currencyCode'],
            amount: rate_data['amount'].to_f,
            rate: rate_data['rate'].to_f,
            country: rate_data['country'],
            currency_name: rate_data['currency']
          )
        end
      end
    end
  end

  class RequestError < StandardError; end
end
