module Api
  module V1
    class CheckoutController < ApiBasicController
      respond_to :json

      def create

        puts params

        render json: {order_number: 4338465}, location: checkout_conclusion_path, status: :created


      end

    end
  end
end