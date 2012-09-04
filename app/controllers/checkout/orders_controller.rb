# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!

  def show
    @order = @user.orders.find_by_number!(params[:number])
    @cart = @order.cart
    @payment = @order.erp_payment
    @payment_response = @payment.payment_response
    @promotion = @order.payments.where(:type => "PromotionPayment").first
    coupon_pm = @order.payments.where(:type => "CouponPayment").first
    coupon = coupon_pm.coupon if coupon_pm
  
    
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
      :credits => @order.payments.where(:type => "CreditPayment").sum(:total_paid)
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
