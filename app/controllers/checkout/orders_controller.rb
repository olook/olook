# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!

  def show
    @order = @user.orders.find_by_number!(params[:number])
    @payment = @order.erp_payment
    promotion = @order.payments.where(:type => "PromotionPayment").first.try(:promotion)
    coupon_pm = @order.payments.where(:type => "CouponPayment").first
    coupon = coupon_pm.coupon if coupon_pm
  
    
    @cart_service_for_order = CartService.new(
      :cart => @order.cart,
      :gift_wrap => @order.gift_wrap ? "1" : "0",
      :coupon => coupon,
      :promotion => promotion,
      :freight => { :price  => @order.freight.price,
        :cost           => @order.freight.cost,
        :delivery_time  => @order.freight.delivery_time,
        :shipping_service_id => @order.freight.shipping_service_id,
        :address_id => @order.freight.address_id
      },
      :credits => @order.payments.where(:type => "CreditPayment").sum(:total_paid)
    )

    @zanpid = request.referer[/.*=([^=]*)/,1] if request.referer =~ /zanpid/
    
  end
end
