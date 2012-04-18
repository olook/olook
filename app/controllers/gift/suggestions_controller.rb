# -*- encoding : utf-8 -*-
class Gift::SuggestionsController < Gift::BaseController
  
  def index
    @gift_recipient = GiftRecipient.find(params[:recipient_id])
    @occasion = GiftOccasion.find(session[:occasion_id])
  end
end
