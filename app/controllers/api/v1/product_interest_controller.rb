module Api
  module V1
    class ProductInterestController < ApplicationController

      respond_to :json

      def create
        respond_with ProductInterest.create(params[:product_interest])
      end

      def product_interest_url(a)
      	"/teste"
      end
    end
  end
end