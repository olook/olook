# -*- encoding : utf-8 -*-
class CreditCardsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order, :only => [:new, :create]
  before_filter :check_user_address, :only => [:new, :create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]

  def new
    @payment = CreditCard.new
    @cart = Cart.new(@order, @freight)
  end

  def create
    @payment = CreditCard.new(params[:credit_card])
    if @payment.valid?
      order = session[:order].reload
      payment_builder = PaymentBuilder.new(order, @payment, @delivery_address)
      @payment = payment_builder.process!
      clean_session_order!
      redirect_to(credit_card_path(@payment), :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end

  def show
    @payment = @user.payments.find(params[:id])
    @payment_response = @payment.payment_response
  end

  def assign_receipt
    params[:credit_card][:receipt] = Payment::RECEIPT
  end
end
