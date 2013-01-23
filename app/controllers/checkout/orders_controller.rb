# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!

  def show
    @google_path_pixel_information = "Purshase"
    @order = @user.orders.find_by_number!(params[:number])
    @payment = @order.erp_payment
    promotion = @order.payments.where(:type => "PromotionPayment").first.try(:promotion)

    coupon_pm = @order.payments.where(:type => "CouponPayment").first
    coupon = coupon_pm.coupon if coupon_pm
    @chaordic_confirmation = ChaordicInfo.buy_order @order

    @cart_service_for_order = CartService.new(
      :cart => @order.cart
    )

    @zanpid = request.referer[/.*=([^=]*)/,1] if request.referer =~ /zanpid/

  end
end
