module ExchangeRates
  module Step
    class Fetch
      def self.call(options, params:, **)
        provider = ExchangeRateProvider::ProviderFactory.call(params[:source_currency])

        options[:result] = provider.call(date: params[:date])

        true
      rescue ExchangeRateProvider::UnsupportedCurrencyError
        options[:result] = []

        true
      rescue ExchangeRateProvider::RequestError => e
        options[:errors] = { base: [e.message] }

        false
      end
    end
  end
end
