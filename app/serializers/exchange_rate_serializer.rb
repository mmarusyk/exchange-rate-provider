class ExchangeRateSerializer < Blueprinter::Base
  def self.render_with_object(rates)
    return {} if rates.empty?

    source_currency = rates.first.source_currency

    rates = rates.each_with_object({}) do |rate, hash|
      hash[rate.target_currency] = ExchangeRateSerializer.render_as_hash(rate, view: :minimal)
    end

    {
      source_currency: source_currency,
      rates: rates
    }
  end

  view :minimal do
    fields :amount, :rate
  end
end
