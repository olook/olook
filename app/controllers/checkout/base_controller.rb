# -*- encoding : utf-8 -*-
class Checkout::BaseController < ApplicationController
  layout "checkout"
  respond_to :html

  private
  def check_cpf
    redirect_to edit_user_registration_path(:checkout_registration => true) unless @user.reseller? || @user.has_valid_cpf?
  end

  def check_order
    return redirect_to cart_path, :notice => "Sua sacola está vazia" if @cart.nil?

    @cart.remove_unavailable_items
    @cart.reload

    #TODO: Produtos com o baixa no estoque foram removidos de sua sacola
    return redirect_to cart_path, :notice => "Sua sacola está vazia" if @cart.items.empty?
    
    coupon = @cart.coupon

    if coupon && (coupon.try(:expired?) || !coupon.try(:available?))
      return redirect_to cart_path, :notice => "Cupom expirado. Informe outro por favor"
    end
  end

  def clean_cart!
    session[:cart_id] = nil
  end
end
