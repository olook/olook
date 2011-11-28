# -*- encoding : utf-8 -*-
module PaymentManager
  def process_payment
    order = session[:order].reload
    payment_builder = PaymentBuilder.new(order, @payment, @delivery_address)
    payment_builder.process!
  end

  def clean_session_order!
    session[:order] = nil
  end

  def check_order
    @order = session[:order]
    msg = "Sua sacola está vazia"
    if @order
      redirect_to(cart_path, :notice => msg) if @order.total <= 0
    else
      redirect_to(cart_path, :notice => msg)
    end
  end

  def check_freight
    @freight = session[:freight]
    redirect_to(addresses_path, :notice => "Informe um endereço") unless @freight
  end

  def load_user
    @user = current_user
  end

  def check_user_address
    @delivery_address = @user.addresses.find_by_id(session[:delivery_address_id])
    redirect_to(addresses_path, :notice => "Informe ou cadastre um endereço") unless @delivery_address
  end
end
