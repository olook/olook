# -*- encoding : utf-8 -*-
class Gift::SuggestionsController < Gift::BaseController
  def index
    @gift_recipient = GiftRecipient.find(params[:recipient_id])
    session[:recipient_id] = @gift_recipient.id
    @profile = @gift_recipient.profile
    @occasion = @gift_recipient.gift_occasions.last
    product_finder_service = ProductFinderService.new(@gift_recipient)
    @suggested_variants = product_finder_service.suggested_variants_for(@gift_recipient.profile, @gift_recipient.shoe_size)
    @products = product_finder_service.showroom_products(:description => @gift_recipient.shoe_size, :not_allow_sold_out_products => true)
  end

  def select_gift
    product = Product.where(:id => params[:product_id]).first
    if product
      @gift_recipient = GiftRecipient.find(params[:recipient_id])
      @variant = product.variant_by_size(@gift_recipient.shoe_size)
    else
      @variant = Variant.find(params[:variant][:id])
    end
  end

  def add_to_cart
    return redirect_to :back, :notice => 'Produtos não foram adicionados' unless params[:products]
    
    @cart.clear
    position = 0
    params[:products].each_pair do |k, id|
      variant = Variant.find(id)
      @cart.add_variant(variant, 1, position, true) if variant
      position += 1
    end
    
    msg = if @cart.cart_items.size > 0
      'Produtos adicionados com sucesso'
    else
      'Um ou mais produtos selecionados não estão disponíveis'
    end
    
    redirect_to cart_path, notice: msg
  end
end
