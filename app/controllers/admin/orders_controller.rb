# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::BaseController
  respond_to :html

  def index
    @search = Order.with_payment.search(params[:search])
    @orders = @search.relation.page(params[:page]).per_page(20).order('id DESC')
  end

  def show
    @order = Order.find(params[:id])
    @address = @order.freight.address
    respond_with :admin, @order, @address
  end
end
