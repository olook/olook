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
    redirect_to(root_path, :notice => "Sua sacola está vazia") unless session[:order]
  end

  def load_user
    @user = current_user
  end

  def check_user_address
    @delivery_address = @user.addresses.find_by_id(session[:delivery_address_id])
    redirect_to(addresses_path, :notice => "Informe ou cadastre um endereço") unless @delivery_address
  end
end
