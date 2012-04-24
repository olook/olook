# -*- encoding : utf-8 -*-
class Gift::SuggestionsController < Gift::BaseController
  def index
    @gift_recipient = GiftRecipient.find(params[:recipient_id])
    @profile = @gift_recipient.profile
    @occasion = GiftOccasion.find(session[:occasion_id])
    product_finder_service = ProductFinderService.new(@gift_recipient)
    @suggested_products = product_finder_service.suggested_products_for(@gift_recipient.profile, @gift_recipient.shoe_size)
    @products = product_finder_service.showroom_products(nil, @gift_recipient.shoe_size)
  end

  def select_gift
    @product = Product.find(params[:product_id])
  end
end
