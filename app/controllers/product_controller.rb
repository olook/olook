# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_product_variant, :only => [:add_to_cart]

  def show
    @product = Product.find(params[:id])
    @variants = @product.variants
  end

  private
  def load_user
    @user = current_user
  end
end

