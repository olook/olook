# -*- encoding : utf-8 -*-
module Api
  module V1
    class NewsletterController < ApiBasicController
      
      def create
        parameters = params[:newsletter].merge({profile: params[:api_client_name]})
        respond_with CampaignEmail.create(parameters)
      end


    end
  end

end