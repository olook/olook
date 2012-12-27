# -*- encoding : utf-8 -*-
class Cart::ItemsController < ApplicationController
	respond_to :js
	before_filter :ensure_params!, :ensure_a_variant_is_found!

  def create  
    add_item_or_show_errors
 
  	update_cart_summary_on_view
  end

  private

  	def update_cart_summary_on_view
  		# renders create.js.erb
  		respond_with { |format| format.js {} }
  	end

  	def add_item_or_show_errors
  		unless @cart.add_item(@variant, variant_qty)
	      respond_with(@cart) do |format|
	        notice_response = @cart.has_gift_items? ? "Produtos de presente não podem ser comprados com produtos da vitrine" : "Produto esgotado"
	        
	        format.js { render :error, locals: { notice: notice_response } }
	      end 
	    end
		end

  	def ensure_a_variant_is_found!
    	respond_with do |format|
        format.js do 
        	render :error, :locals => { :notice => "Por favor, selecione o tamanho do produto." }
        end
      end unless @variant = Variant.find_by_id(variant_id)
  	end

  	def ensure_params!
  		respond_with do |format|
        format.js do 
        	render :error, :locals => { :notice => "Por favor, selecione o tamanho do produto." }
        end	        
      end unless params[:variant] && params[:variant][:id]
  	end

  	def variant_id
  		params[:variant][:id]
  	end

  	def variant_qty
  		params[:variant][:quantity]
  	end

end