# -*- encoding : utf-8 -*-
module Api
  module V1
    class ProductInterestController < ApiBasicController

      def create
     		respond_with ProductInterest.creates_for(params[:email], params[:product_id]), location: '/'
      end

    end
  end
end