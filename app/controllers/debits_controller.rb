# -*- encoding : utf-8 -*-
class DebitsController < ApplicationController
  layout "checkout"

  include Checkout
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_inventory, :only => [:create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :build_cart, :only => [:new, :create]
  before_filter :load_promotion

  def new
    @payment = Debit.new
  end

  def create
    @payment = Debit.new(params[:debit])
    if @payment.valid?
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_session_order!
        redirect_to(order_debit_path(:number => @order.number), :notice => "Link de pagamento gerado com sucesso")
      else
        respond_with(new_payment_with_error)
      end
     else
      respond_with(@payment)
    end
  end

  private

  def new_payment_with_error
    @payment = Debit.new(params[:debit])
    @payment.errors.add(:id, "Não foi possível realizar o pagamento.")
    @payment
  end

  def assign_receipt
    if params[:debit]
      params[:debit][:receipt] = Payment::RECEIPT
    else
      params.merge!(:debit => {:receipt => Payment::RECEIPT})
    end
  end
end
