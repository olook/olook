# -*- encoding : utf-8 -*-
class Cart::ItemsController < ApplicationController
	respond_to :js
	before_filter :ensure_params!, :ensure_a_variant_is_found!

  def create  
    add_item_or_show_errors
 
  	update_cart_summary_on_view
  end

  def destroy
  	cart_item = @cart.items.find(params[:id])
  	@product_id = cart_item.product.id
    if cart_item.destroy
      respond_with { |format| format.js { } }
    else
      render :error, :locals => { :notice => "Houve um problema ao deletar o item do cart" }
    end
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
      return if removing_a_cart_item?
    	respond_with do |format|
        format.js do 
        	render :error, :locals => { :notice => "Por favor, selecione o tamanho do produto." }
        end
      end unless a_variant_is_found
  	end

    def a_variant_is_found
      @variant = Variant.find_by_id(variant_id)
    end

  	def ensure_params!
      if post_to_create?
    		respond_with do |format|
          format.js do 
          	render :error, :locals => { :notice => "Por favor, selecione o tamanho do produto." }
          end	        
        end unless (params[:variant] && params[:variant][:id])
      else 
        respond_with do |format|
          format.js do 
            render :error, :locals => { :notice => "Houve um problema ao deletar o item do carrinho" }
          end         
        end unless (params[:id] && !params[:id].empty?)
      end
  	end

    def post_to_create?
      request.method == 'POST'
    end

    def removing_a_cart_item?
      request.method == 'DELETE'
    end

  	def variant_id
  		params[:variant][:id]
  	end

  	def variant_qty
  		params[:variant][:quantity]
  	end

end