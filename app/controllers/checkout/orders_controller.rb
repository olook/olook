# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!

  def show
    @google_path_pixel_information = "Purshase"
    @order = @user.orders.find_by_number!(params[:number])
    @payment = @order.erp_payment
    promotion = @order.payments.where(:type => "PromotionPayment").first.try(:promotion)

    @cart_service_for_order = CartService.new(
      :cart => @order.cart,
      :promotion => promotion
    )

    @zanpid = request.referer[/.*=([^=]*)/,1] if request.referer =~ /zanpid/

  end
end
