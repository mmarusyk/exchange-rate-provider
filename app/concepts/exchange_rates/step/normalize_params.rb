module ExchangeRates
  module Step
    class NormalizeParams
      def self.call(options, params:, **)
        params[:source_currency] = params[:source_currency].to_s.upcase if params[:source_currency]
        params[:target_currency] = Array(params[:target_currency]).map(&:upcase)
        options[:params] = params

        true
      end
    end
  end
end
