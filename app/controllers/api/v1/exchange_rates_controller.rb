module Api
  module V1
    class ExchangeRatesController < ApplicationController
      def index
        operation = ExchangeRates::Operation::Index.call(params: params)

        if operation.success?
          render json: ExchangeRateSerializer.render_with_object(operation[:result]), status: :ok
        else
          render json: { errors: operation[:errors] }, status: :unprocessable_entity
        end
      end
    end
  end
end
