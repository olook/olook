# -*- encoding : utf-8 -*-
class BilletsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order, :only => [:new, :create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :check_user_address, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]


  def new
    @payment = Billet.new
  end

  def create
    @payment = Billet.new(params[:billet])
    if @payment.valid?
      order = session[:order].reload
      payment_builder = PaymentBuilder.new(order, @payment, @delivery_address)
      @payment = payment_builder.process!
      clean_session_order!
      redirect_to(billet_path(@payment), :notice => "Sucesso")
    else
      respond_with(@payment)
    end
  end

  def show
    @payment = @user.payments.find(params[:id])
  end

  private

  def assign_receipt
    params[:billet][:receipt] = Payment::RECEIPT
  end
end
