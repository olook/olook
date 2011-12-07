# -*- encoding : utf-8 -*-
class User::OrdersController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_order

  def index
    @orders = @user.orders.page(params[:page]).per_page(8)
  end

  def show
    @order = Order.find(params[:id])
    @order_presenter = OrderStatus.new(@order)
  end

  private

  def load_user
    @user = current_user
  end
end
