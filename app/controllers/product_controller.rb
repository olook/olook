# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :current_order

  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    @variant = Variant.find(params[:variant][:id])
    @order.add_variant(@variant)
  end

  private
  def current_order
    @order = (session[:order] ||= @user.orders.create)
  end

  def load_user
    @user = current_user
  end
end
