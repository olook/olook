# -*- encoding : utf-8 -*-
class Checkout::OrdersController < Checkout::BaseController
  before_filter :authenticate_user!

  def show
    @order = @user.orders.find_by_number!(params[:number])
    @payment = @order.payment
    @payment_response = @payment.payment_response
    @promotion = @order.used_promotion.promotion if @order.used_promotion
    
    if @payment.is_a? Billet
      return render :billet
    elsif @payment.is_a? CreditCard
      return render :credit_card
    else
      return render :debit
    end
  end
end
