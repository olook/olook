class PricesController < ApplicationController
  def index
    ids = params[:product_ids].is_a?(Array) ? params[:product_ids] : params[:product_ids].to_s.split(/\D/).select {|i| i.present? }
    @products = Product.only_visible.where(id: ids)
    @promotion = Promotion.select_promotion_for(@cart)
    prices = @products.map do |p|
      Rails.logger.debug("Check #{p.id}")
      if p.discount_price(cart: @cart, coupon: @cart.coupon, promotion: @promotion) != p.price
        price_hash = { de: ActionController::Base.helpers.number_to_currency(p.price), por: ActionController::Base.helpers.number_to_currency(p.discount_price(cart: @cart)) }
        [ p.id, price_hash ]
      end
    end.compact
    render json: { prices: Hash[prices] }
  end
end
