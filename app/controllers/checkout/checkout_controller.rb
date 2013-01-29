# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :check_cpf

  def new
    @addresses = @user.addresses
    @report  = CreditReportService.new(@user)
    address = @addresses.first || Address.new
    @checkout = Checkout.new(address: address)
  end

  def create
    address = shipping_address(params)
    payment = create_payment(address)
    payment_method = params[:checkout][:payment_method]

    payment_valid = payment && payment.valid?
    address_valid = address && address.valid?
    unless payment_valid & address_valid
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
      @addresses = @user.addresses
      error_message = "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento." if payment.is_a? CreditCard
      display_form(address, payment, payment_method)
      return
    end
  end

  private

  def shipping_address(params)
    if using_address_form?
      populate_shipping_address
    else
      Address.find_by_id(params[:address][:id]) if params[:address]
    end
  end

  def populate_shipping_address
    params[:checkout][:address][:country] = 'BRA'
    address = params[:checkout][:address][:id].blank? ? @user.addresses.build() : @user.addresses.find(params[:checkout][:address][:id])
    params[:checkout][:address].delete(:id)
    address.assign_attributes(params[:checkout][:address])
    address
  end

  def create_payment(address)
    params[:checkout][:payment][:receipt] = Payment::RECEIPT
    params[:checkout][:payment][:telephone] = address.telephone if address

    payment = case params[:checkout][:payment_method]
    when "billet"
      Billet.new(params[:checkout][:payment])
    when "debit"
      Debit.new(params[:checkout][:payment])
    when "credit_card"
      CreditCard.new(params[:checkout][:payment] )
    else
      nil
    end
  end

  def display_form(address, payment, payment_method, error_message = nil)
    @report  = CreditReportService.new(@user)
    @checkout = Checkout.new(address: address, payment: payment, payment_method: payment_method)
    if error_message
      @checkout.errors.add(:base, error_message)
    end

    unless using_address_form?
      @addresses = @user.addresses
      unless address
        @checkout.address = Address.new
        @checkout.errors.add(:base, "Escolha um endereço!")
      end
    end

    unless payment
      @checkout.errors.add(:base, "Como você pretende pagar? Escolha uma das opções")
    end

    render :new
  end

  def using_address_form?
    !params[:checkout][:address].nil?
  end

end
