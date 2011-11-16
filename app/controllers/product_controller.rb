# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  before_filter :authenticate_user!

  def index
    @product = Product.find(params[:id])
  end
end
