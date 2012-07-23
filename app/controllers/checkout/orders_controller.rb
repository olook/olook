# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!
  before_filter :load_resources

  def billet
  end

  def credit
  end

  def debit
  end

  private
  def load_resources
    @order = @user.orders.find_by_number!(params[:number])
    @payment = @order.payment
    @payment_response = @payment.payment_response
    @promotion = @order.used_promotion.promotion if @order.used_promotion
  end
end
