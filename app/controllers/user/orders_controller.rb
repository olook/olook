# -*- encoding : utf-8 -*-
class User::OrdersController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_order

  def index
    @orders = @user.orders.with_payment.order('created_at DESC').page(params[:page]).per_page(8)
  end

  def show
    @current_order = Order.find(params[:id])
    @address = @current_order.freight.address
    @order_presenter = OrderStatus.new(@current_order)
  end

  private

  def load_user
    @user = current_user
  end
end
