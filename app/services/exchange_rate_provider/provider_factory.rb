module ExchangeRateProvider
  class ProviderFactory
    def self.call(source_currency)
      case source_currency.to_s.upcase
      when CZK_CURRENCY
        Providers::CnbProvider.instance
      else
        raise UnsupportedCurrencyError, "No provider available for #{source_currency}"
      end
    end
  end

  class UnsupportedCurrencyError < StandardError; end
end
