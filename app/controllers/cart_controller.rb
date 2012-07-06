# -*- encoding : utf-8 -*-
class CartController < ApplicationController
  layout "checkout"

  respond_to :html, :js
  before_filter :check_product_variant, :only => [:create, :update]
  before_filter :format_credits_value, :only => [:update_bonus]

  def show
    # @bonus = @user.current_credit - @order.credits
    # @cart = CartPresenter.new(@order)
    # @line_items = @order.line_items
    # @coupon_code = @order.used_coupon.try(:code)
    # unless @coupon_code
    #   PromotionService.new(current_user, @order).apply_promotion if @promotion
    # end
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to cart_path, :notice => "Sua sacola está vazia"
  end

  def update
    respond_with do |format|
      if @cart.remove_variant(@variant)
        format.html { redirect_to cart_path, :notice => "Produto removido com sucesso" }
        format.js { head :ok }
      else
        format.js { head :not_found }
        format.html { redirect_to cart_path, :notice => "Este produto não está na sua sacola" }
      end
    end
  end

  def create
    if @cart.add_variant(@variant)
      respond_with do |format|
        format.js do
          render partial: "shared/cart_line_item", locals: { item: @order.line_items.detect { |li| li.variant_id == @variant.id }, hidden: true }, :layout => false, status: :created
        end
        format.html { redirect_to(cart_path, :notice => "Produto adicionado com sucesso") }
      end
    else
      respond_with(@cart) do |format|
        notice_response = @cart.restricted? ? "Produtos de presente não podem ser comprados com produtos da vitrine" : "Produto esgotado"
        format.js { render :error, :locals => { notice: notice_response } }
        format.html { redirect_to(cart_path, :notice => notice_response) }
      end
    end
  end
  
  def update_gift_wrap
    @cart.update_attributes(gift_wrap: params[:gift][:gift_wrap]) if params[:gift] && params[:gift][:gift_wrap]
    render :json => true
  end
  
  def update_coupon
    
  end
  
  private
  def format_credits_value
    params[:credits][:value].gsub!(",",".")
  end


  def check_product_variant
    variant_id = params[:variant][:id] if params[:variant]
    @variant = Variant.find_by_id(variant_id)
    unless @variant.try(:available_for_quantity?)
      respond_with do |format|
        format.js { render :error, :locals => { :notice => "Por favor, selecione os atributos do produto." }}
        format.html { redirect_to(:back, :notice => "Produto não disponível para esta quantidade ou inexistente") }
      end
    end
  end
end

