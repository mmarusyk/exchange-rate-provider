require 'dry/validation'

module ExchangeRates
  module Contract
    class Params < Dry::Validation::Contract
      params do
        required(:source_currency).filled(:string)
        optional(:target_currency).maybe(:array).each(:string)
        optional(:date).maybe(:string)
        optional(:lang).maybe(:string)
      end

      rule(:source_currency) do
        key.failure('must be a valid 3-letter currency code') unless value.match?(/\A[A-Z]{3}\z/)
      end

      rule(:target_currency) do
        value&.each do |currency|
          key.failure('each target currency must be a valid 3-letter code') unless currency.match?(/\A[A-Z]{3}\z/)
        end
      end

      rule(:date) do
        key.failure('must be in the format YYYY-MM-DD') if value && !value.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      end
    end
  end
end
