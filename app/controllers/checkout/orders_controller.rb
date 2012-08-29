# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!

  def show
    @order = @user.orders.find_by_number!(params[:number])
    @cart = @order.cart
    @payment = @order.erp_payment
    @payment_response = @payment.payment_response
    @promotion = @order.used_promotion.promotion if @order.used_promotion
    coupon = @order.used_coupon.coupon if @order.used_coupon
    
    @cart_service = CartService.new(
      :cart => @cart,
      :gift_wrap => @order.gift_wrap ? "1" : "0",
      :coupon => coupon,
      :promotion => @promotion,
      :freight => { :price  => @order.freight.price,
        :cost           => @order.freight.cost,
        :delivery_time  => @order.freight.delivery_time,
        :shipping_service_id => @order.freight.shipping_service_id,
        :address_id => @order.freight.address_id
      },
      :credits => @order.credits
    )
    
    
    if @payment.is_a? Billet
      return render :billet
    elsif @payment.is_a? CreditCard
      return render :credit
    else
      return render :debit
    end
  end
end
