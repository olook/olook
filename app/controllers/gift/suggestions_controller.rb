# -*- encoding : utf-8 -*-
class Gift::SuggestionsController < Gift::BaseController
  
  def index
    @gift_recipient = GiftRecipient.find(params[:recipient_id])
    @occasion = GiftOccasion.find(session[:occasion_id])
  end

  def select_gift
    @product = Product.find(params[:product_id])
  end
end
