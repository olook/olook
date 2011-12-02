# -*- encoding : utf-8 -*-
module PaymentManager
  def build_cart
    @cart = Cart.new(@order)
  end

  def clean_session_order!
    session[:order] = nil
    session[:freight] = nil
    session[:delivery_address_id] = nil
  end

  def check_order
    @order = @user.orders.find_by_id(session[:order])
    msg = "Sua sacola está vazia"
    if @order
      redirect_to(cart_path, :notice => msg) if @order.total <= 0
    else
      redirect_to(cart_path, :notice => msg)
    end
  end

  def check_freight
    @freight = @order.freight
    redirect_to(addresses_path, :notice => "Informe um endereço") unless @freight
  end

  def check_user_address
    @delivery_address = @user.addresses.find_by_id(session[:delivery_address_id])
    redirect_to(addresses_path, :notice => "Informe ou cadastre um endereço") unless @delivery_address
  end
end
