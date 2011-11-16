# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_user_address

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
      order = @user.orders.create
      payment_builder = PaymentBuilder.new(order, @payment, @delivery_address)
      payment_builder.process!
      redirect_to(root_path, :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end

  private

  def load_user
    @user = current_user
  end

  def check_user_address
    address_id = params[:delivery_address_id] || session[:delivery_address_id]
    @delivery_address = @user.addresses.where(:id => address_id).first
    redirect_to(addresses_path, :notice => "Informe ou cadastre um endereço") unless @delivery_address
  end
end
