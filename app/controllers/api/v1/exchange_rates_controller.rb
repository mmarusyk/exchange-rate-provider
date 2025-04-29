module Api
  module V1
    class ExchangeRatesController < ApplicationController
      def index
        result = ExchangeRates::Operation::Index.call(params: params)

        if result.success?
          render json: ExchangeRateSerializer.render(result[:exchange_rates]), status: :ok
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end
    end
  end
end
