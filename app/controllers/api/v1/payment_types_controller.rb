# -*- encoding : utf-8 -*-
module Api
  module V1
    class PaymentTypesController < ApiBasicController
      before_filter :authenticate_user!
      def index
        render json: Api::PaymentTypes.types.to_json, status: :ok
      end
    end
  end
end
