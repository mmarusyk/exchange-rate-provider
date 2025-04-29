class ExchangeRateSerializer < Blueprinter::Base
  DEFAULT_ROUND = 4

  identifier :target_currency

  fields :date, :source_currency, :target_currency, :amount, :rate, :country, :currency_name
end
