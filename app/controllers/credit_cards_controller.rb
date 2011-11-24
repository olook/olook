# -*- encoding : utf-8 -*-
class CreditCardsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order
  before_filter :check_user_address, :only => [:new, :create]

  def new
    @payment = CreditCard.new
  end

  def create
    @payment = CreditCard.new(params[:credit_card])
    if @payment.valid?
      order = session[:order].reload
      payment_builder = PaymentBuilder.new(order, @payment, @delivery_address)
      payment_builder.process!
      clean_session_order!
      redirect_to(root_path, :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end
end
