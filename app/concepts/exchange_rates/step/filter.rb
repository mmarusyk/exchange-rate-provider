module ExchangeRates
  module Step
    class Filter
      def self.call(options, params:, result:, **)
        return true if params[:target_currency].empty?

        options[:result] = result.select do |rate|
          params[:target_currency].include?(rate.target_currency)
        end

        true
      end
    end
  end
end
