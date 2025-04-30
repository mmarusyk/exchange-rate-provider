module ExchangeRates
  module Operation
    class Index < Trailblazer::Operation
      step Trb::Step::SanitizeParams
      step ExchangeRates::Step::NormalizeParams
      step ExchangeRates::Step::ValidateParams
      step ExchangeRates::Step::Fetch
      step ExchangeRates::Step::Filter
    end
  end
end
