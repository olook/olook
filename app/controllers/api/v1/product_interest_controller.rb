# -*- encoding : utf-8 -*-
module Api
  module V1
    class ProductInterestController < ApiBasicController

      def create
        product_interest = ProductInterest.creates_for(params[:email], params[:product_id], params[:product_color], params[:product_subcategory])
        status = product_interest.errors.any? ? :unprocessable_entity : :ok
     		respond_with product_interest, location: '/', status: status
      end

    end
  end
end
