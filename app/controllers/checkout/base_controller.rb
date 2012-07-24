# -*- encoding : utf-8 -*-
class Checkout::BaseController < ApplicationController
  layout "checkout"
  respond_to :html
  
  private
  def erase_freight
    @cart.freight = nil
  end

  def check_freight
    redirect_to cart_checkout_addresses_path, :notice => "Escolha seu endereço" if @cart.freight.nil?
  end
  
  def check_cpf
    redirect_to new_cart_checkout_path, :notice => "Informe seu CPF" unless Cpf.new(@user.cpf).valido?
  end
  
  def check_order
    msg = "Sua sacola está vazia"
    if @cart
      @cart.remove_unavailable_items
      @cart.reload
      redirect_to(cart_path, :notice => msg) if @cart.items.empty?
      coupon = @cart.used_coupon.try(:coupon)
      if coupon.try(:expired?) || @cart.used_coupon && !coupon.try(:available?)
        @cart.used_coupon.try(:destroy)
        redirect_to cart_path, :notice => "Cupom expirado. Informe outro por favor"
      end
      if @cart.user.current_credit < @cart.credits
        @cart.credits = 0
        @cart.save
        redirect_to cart_path, :notice => "Você não tem créditos suficientes"
      end
    else
      redirect_to(cart_path, :notice => msg)
    end
  end
  
  def clean_cart!
    session[:cart_id] = nil
    session[:gift_wrap] = nil
    session[:session_coupon] = nil
    session[:credits] = nil
    session[:freight] = nil
  end
end