# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :check_cpf, :except => [:new, :update]

  def update
    cpf = params[:user][:cpf] if params[:user]
    msg = "CPF inválido"

    if !@user.cpf.blank?
      msg = "CPF já cadastrado"
    else
      @user.require_cpf = true
      @user.cpf = cpf
      msg = "CPF cadastrado com sucesso" if @user.save
    end

    @user.errors.clear

    flash[:notice] = msg
    render :new
  end

  def new
    @addresses = @user.addresses
    @checkout = Checkout.new(address: Address.new, payment: CreditCard.new)
  end

  def create
    address = shipping_address
    payment = create_payment(address)
    unless address && address.valid? && payment.valid?
      display_form(address, payment)
      return
    end

    address.save
    @cart.address = address

    redirect_to :new_cart_checkout
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

  def display_form(address, payment)
    @addresses = @user.addresses
    @checkout = Checkout.new(address: address, payment: payment)
    render :new
  end

  def create_payment(address)
    params[:checkout][:payment][:receipt] = Payment::RECEIPT
    params[:checkout][:payment][:telephone] = address.telephone if address
    payment = CreditCard.new(params[:checkout][:payment] )
  end

  # def create_credit_card
  #   params[:credit_card][:receipt] = Payment::RECEIPT if params[:credit_card]
  #   @payment = CreditCard.new(params[:credit_card])
  #   @payment.telephone = session[:user_telephone_number] || current_user.addresses.first.telephone
  #   @bank = params[:credit_card][:bank] if params[:credit_card]
  #   @installments = params[:credit_card][:payments] if params[:credit_card]
  #   if @payment.valid?
  #     sender_strategy = PaymentService.create_sender_strategy(@cart_service, @payment)
  #     sender_strategy.credit_card_number =  params[:credit_card][:credit_card_number]
  #     payment_builder = PaymentBuilder.new({ :cart_service => @cart_service, :payment => @payment, :gateway_strategy => sender_strategy, :tracking_params => session[:order_tracking_params] } )
  #     response = payment_builder.process!

  #     if response.status == Payment::SUCCESSFUL_STATUS
  #       clean_cart!
  #       return redirect_to(order_show_path(:number => response.payment.order.number))
  #     else
  #       @payment = CreditCard.new(params[:credit_card])
  #       @payment.telephone = session[:user_telephone_number] || current_user.addresses.first.telephone
  #       @payment.user_identification = @user.cpf
  #       @payment.errors.add(:base, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
  #       @payment
  #     end
  #   end

  #   render :new_credit_card
  # end

end
