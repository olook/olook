# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  respond_to :html
  before_filter :load_user
  before_filter :check_user_address, :only => [:new]

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
    delivery_address = @user.addresses.create(:country =>'BRA', :city => 'Sao Paulo', :state => 'SP', :complement => 'ap 56' , :street => 'Rua Joao de Castro', :number => '100', :neighborhood => 'Centro', :zip_code => '37713-172', :telephone => '(31)2345-8759')

    if @payment.valid?
      order = @user.orders.create
      payment_builder = PaymentBuilder.new(order, @payment, delivery_address)
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
    address_id = session[:delivery_address_id]
    @delivery_address = @user.addresses.find(address_id) if address_id
    redirect_to(new_address_path, :notice => "Informe ou cadastre um endereço") unless @delivery_address
  end
end
