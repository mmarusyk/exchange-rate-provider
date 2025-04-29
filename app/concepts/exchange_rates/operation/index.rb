module ExchangeRates
  module Operation
    class Index < Trailblazer::Operation
      step Trb::Step::SanitizeParams
      step ExchangeRates::Step::NormalizeParams
      step ExchangeRates::Step::ValidateParams
      step ExchangeRates::Step::FetchExchangeRates
    end
  end
end
