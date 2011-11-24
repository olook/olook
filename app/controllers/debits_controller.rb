# -*- encoding : utf-8 -*-
class DebitsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order
  before_filter :check_user_address, :only => [:new, :create]

  def new
    @payment = Debit.new
  end

  def create
    @payment = Debit.new(params[:debit])
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
