module ExchangeRateProvider
  class ExchangeRate < Dry::Struct
    attribute :source_currency, Types::CurrencyCode
    attribute :target_currency, Types::CurrencyCode
    attribute :amount, Types::PositiveFloat.default(1.0)
    attribute :rate, Types::PositiveFloat
  end
end
