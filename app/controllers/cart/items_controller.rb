# -*- encoding : utf-8 -*-
class Cart::ItemsController < ApplicationController
	before_filter :load_cart

  def create
  	@cart.items.create(params)
    render text: ''
  end

  private

  	def load_cart
  		@cart ||= Cart.find(session[:cart_id])
  	end

end