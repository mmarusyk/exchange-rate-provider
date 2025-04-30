module ExchangeRates
  module Contract
    class Params < Dry::Validation::Contract
      params do
        required(:source_currency).filled(ExchangeRateProvider::Types::CurrencyCode)
        optional(:target_currency).maybe(:array).each(ExchangeRateProvider::Types::CurrencyCode)
        optional(:date).maybe(ExchangeRateProvider::Types::Date)
      end
    end
  end
end
