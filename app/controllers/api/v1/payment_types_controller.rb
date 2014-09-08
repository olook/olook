# -*- encoding : utf-8 -*-
module Api
  module V1
    class PaymentTypesController < ApiBasicController
      before_filter :authenticate_user!
      def index
        render json: Api::V1::PaymentType.all.to_json, status: :ok
      end
    end
  end
end
