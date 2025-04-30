class ExchangeRateSerializer < Blueprinter::Base
  DEFAULT_ROUND = 4

  identifier :target_currency

  fields :source_currency, :amount, :rate
end
