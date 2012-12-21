# -*- encoding : utf-8 -*-
class Cart::ItemsController < ApplicationController

  def create
    redirect_to cart_path
  end

  def destroy
    redirect_to cart_path
  end

end