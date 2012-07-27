# -*- encoding : utf-8 -*-
class Checkout::BaseController < ApplicationController
  layout "checkout"
  respond_to :html
  before_filter :load_cart_service
  
  
  private
  def load_cart_service
    @cart_service = CartService.new(
      :cart => @cart,
      :gift_wrap => session[:gift_wrap],
      :coupon => session[:cart_coupon],
      :promotion => @promotion,
      :freight => session[:cart_freight],
      :credits => session[:cart_credits]
    )
  end
  
  def erase_freight
    @cart_service.freight = nil
  end
  
  def check_freight
    redirect_to cart_checkout_addresses_path, :notice => "Escolha seu endereço" if @cart.freight.nil?
  end
  
  def check_cpf
    redirect_to new_cart_checkout_path, :notice => "Informe seu CPF" unless Cpf.new(@user.cpf).valido?
  end
  
  def check_order
    return redirect_to cart_path, :notice => "Sua sacola está vazia" if @cart.nil?

    @cart.remove_unavailable_items
    @cart.reload
    
    return redirect_to cart_path, :notice => "Sua sacola está vazia" if @cart.items.empty?
    
    coupon = @cart_service.coupon
    if coupon && (coupon.try(:expired?) || !coupon.try(:available?))
      session[:cart_coupon] = nil
      return redirect_to cart_path, :notice => "Cupom expirado. Informe outro por favor"
    end
    
    credits = @cart_service.credits
    credits ||= 0
    if credits > 0 && !@cart.user.can_use_credit?(credits)
      session[:cart_credits] = nil
      return redirect_to cart_path, :notice => "Você não tem créditos suficientes"
    end
  end
  
  def clean_cart!
    session[:cart_id] = nil
    session[:gift_wrap] = nil
    session[:cart_coupon] = nil
    session[:cart_credits] = nil
    session[:cart_freight] = nil
  end
end