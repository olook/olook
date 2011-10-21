# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  def index
    @product = Product.find(params[:id])
  end
end
