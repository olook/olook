# -*- encoding : utf-8 -*-
class Cart::ItemsController < ApplicationController
	before_filter :load_cart
	respond_to :js

  def create
  	#TODO return an error if these params aren't present, shouldn't 
  	# need to be checking them
    variant_id = params[:variant][:id] if params[:variant]
    variant_quantity = params[:variant][:quantity] if params[:variant]

    @variant = Variant.find_by_id(variant_id)
    @cart.add_item(@variant, variant_quantity)

    respond_with { |format| format.js {} }
  end

  private

  	def load_cart
			binding.pry

  		@cart ||= Cart.find(session[:cart_id])
  	end

end