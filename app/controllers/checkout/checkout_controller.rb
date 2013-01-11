# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :check_cpf, :except => [:new, :update]

  def new
    @addresses = @user.addresses
    @checkout = Checkout.new(address: Address.new, payment: CreditCard.new)
  end

  def create
    address = shipping_address
    payment = create_payment(address)
    payment_method = params[:checkout][:payment_method]
    unless address && address.valid? && payment.valid?
      display_form(address, payment, payment_method)
      return
    end

    address.save
    @cart_service.cart.address = address

    sender_strategy = PaymentService.create_sender_strategy(@cart_service, payment)
    payment_builder = PaymentBuilder.new({ :cart_service => @cart_service, :payment => payment, :gateway_strategy => sender_strategy, :tracking_params => session[:order_tracking_params] } )
    response = payment_builder.process!

    if response.status == Payment::SUCCESSFUL_STATUS
      clean_cart!
      return redirect_to(order_show_path(:number => response.payment.order.number))
    else
      payment.errors.add(:base, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
      display_form(address, payment, payment_method)
      return
    end
  end

  private

  def shipping_address
    if params[:checkout][:address]
      populate_shipping_address
    else
      Address.find(params[:address][:id]) if params[:address]
    end
  end

  def populate_shipping_address
    params[:checkout][:address][:country] = 'BRA'
    address = params[:checkout][:address][:id].empty? ? @user.addresses.build() : @user.addresses.find(params[:checkout][:address][:id])
    params[:checkout][:address].delete(:id)
    address.assign_attributes(params[:checkout][:address])
    address
  end

  def create_payment(address)
    params[:checkout][:payment][:receipt] = Payment::RECEIPT
    params[:checkout][:payment][:telephone] = address.telephone if address
    payment = CreditCard.new(params[:checkout][:payment] )
  end

  def display_form(address, payment, payment_method)
    @addresses = @user.addresses
    @checkout = Checkout.new(address: address, payment: payment, payment_method: payment_method)
    render :new
  end

end
