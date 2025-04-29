module ExchangeRateProvider
  module Types
    include Dry.Types()

    Date = Types::Strict::String.constrained(format: /\A\d{4}-\d{2}-\d{2}\z/)
    PositiveInteger = Types::Strict::Integer.constrained(gt: 0)
    PositiveFloat = Types::Strict::Float.constrained(gt: 0)
    CurrencyCode = Types::Strict::String.constrained(format: /\A[A-Z]{3}\z/)
  end
end
