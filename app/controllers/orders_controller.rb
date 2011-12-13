# -*- encoding : utf-8 -*-
class OrdersController < ApplicationController
  layout "checkout"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
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
    @cart = Cart.new(@order)
  end
end
