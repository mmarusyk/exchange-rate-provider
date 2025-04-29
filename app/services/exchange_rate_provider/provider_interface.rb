module ExchangeRateProvider
  class ProviderInterface
    def self.for(source_currency)
      case source_currency.to_s.upcase
      when 'CZK'
        Providers::CnbProvider.new
      else
        raise UnsupportedCurrencyError, "No provider available for #{source_currency}"
      end
    end

    def call(date: nil, lang: nil)
      raise NotImplementedError, "#{self.class} must implement #fetch_rates"
    end

    def name
      self.class.name.demodulize
    end
  end

  class UnsupportedCurrencyError < StandardError; end
end
