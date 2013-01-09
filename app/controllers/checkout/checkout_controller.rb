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
    @checkout = Checkout.new(address: Address.new)
  end

  def create
    params[:checkout][:address][:country] = 'BRA' if params[:checkout][:address]
    address = params[:checkout][:address][:id].empty? ? @user.addresses.build() : @user.addresses.find(params[:checkout][:address][:id])
    params[:checkout][:address].delete(:id)
    address.assign_attributes(params[:checkout][:address])      

    if address.save
      redirect_to :new_cart_checkout
    else
      @checkout = Checkout.new(address: address)
      render :new
    end
  end

end
