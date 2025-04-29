module ExchangeRates
  module Step
    class ValidateParams
      def self.call(options, params:, **)
        contract = ExchangeRates::Contract::Params.new
        validation = contract.call(params)

        if validation.success?
          options[:params] = validation.to_h

          true
        else
          options[:errors] = validation.errors.to_h

          false
        end
      end
    end
  end
end
