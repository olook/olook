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
    return unless address && address.valid?

    redirect_to :new_cart_checkout
  end

  private

  def shipping_address
    if params[:checkout][:address]
      address = populate_shipping_address
      display_form(address, CreditCard.new) unless address.save
      address
    else
      address = Address.find(params[:address][:id]) if params[:address]
      display_form(Address.new, CreditCard.new) unless address
      address
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

end
