module ExchangeRateProvider
  class ExchangeRate < Dry::Struct
    attribute :date, Types::Date
    attribute :source_currency, Types::CurrencyCode
    attribute :target_currency, Types::CurrencyCode
    attribute :amount, Types::PositiveFloat.default(1.0)
    attribute :rate, Types::PositiveFloat
    attribute :country, Types::String.optional
    attribute :currency_name, Types::String.optional

    def convert(amount_to_convert = 1.0)
      (amount_to_convert * rate) / amount
    end
  end
end
