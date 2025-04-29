module ExchangeRates
  module Step
    class FetchExchangeRates
      def self.call(options, params:, **)
        fetcher = new(options, params)
        fetcher.perform
      end

      def initialize(options, params)
        @options = options
        @params = params
      end

      def perform
        fetch_rates
        filter_rates if @params[:target_currency].any?
        store_results

        true
      rescue ExchangeRateProvider::UnsupportedCurrencyError => e
        handle_error(:source_currency, e.message)

        false
      rescue ExchangeRateProvider::RequestError => e
        handle_error(:base, e.message)

        false
      end

      private

      def fetch_rates
        provider = ExchangeRateProvider::ProviderInterface.for(@params[:source_currency])
        @rates = provider.call(date: @params[:date], lang: @params[:lang])
      end

      def filter_rates
        @rates = @rates.select { |rate| @params[:target_currency].include?(rate.target_currency) }
      end

      def store_results
        @options[:exchange_rates] = @rates
      end

      def handle_error(key, message)
        @options[:errors] = { key => [message] }
      end
    end
  end
end
