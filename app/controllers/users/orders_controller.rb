# -*- encoding : utf-8 -*-
class Users::OrdersController < ApplicationController

  respond_to :html
  before_filter :authenticate_user!

  def index
    @orders = @user.orders.with_payment.uniq.order('created_at DESC').page(params[:page]).per_page(8)
  end

  def show
    @current_order = @user.orders.find_by_number(params[:number])
    @address = @current_order.freight.address unless @current_order.try(:freight).nil?
    @order_presenter = OrderStatus.new(@current_order)
  end

end
