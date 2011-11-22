# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order
  before_filter :check_user_address, :only => [:new, :create]

  def index
    @payments = Payment.all
    respond_with(@payments)
  end

  def show
    @payment = Payment.find(params[:id])
    respond_with(@payment)
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(params[:payment])

    if @payment.valid?
      order = session[:order].reload
      payment_builder = PaymentBuilder.new(order, @payment, @delivery_address)
      payment_builder.process!
      redirect_to(root_path, :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end

  private

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
