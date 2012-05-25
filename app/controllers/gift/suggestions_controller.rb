# -*- encoding : utf-8 -*-
class Gift::SuggestionsController < Gift::BaseController
  def index
    @gift_recipient = GiftRecipient.find(params[:recipient_id])
    session[:recipient_id] = @gift_recipient.id
    @profile = @gift_recipient.profile
    @occasion = @gift_recipient.gift_occasions.last
    product_finder_service = ProductFinderService.new(@gift_recipient)
    @suggested_products = product_finder_service.suggested_products_for(@gift_recipient.profile, @gift_recipient.shoe_size)
    @products = product_finder_service.showroom_products(:description => @gift_recipient.shoe_size, :not_allow_sold_out_products => true)
  end

  def select_gift
    @product = Product.find(params[:product_id])
  end
end
