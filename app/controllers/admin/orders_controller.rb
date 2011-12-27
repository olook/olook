# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::BaseController
  respond_to :html

  def index
    @orders = Order.with_payment.page(params[:page]).per_page(20).order('id DESC')
    respond_with :admin, @orders
  end

  def show
    @order = Order.find(params[:id])
    @address = @order.freight.address
    respond_with :admin, @order, @address
  end
end
