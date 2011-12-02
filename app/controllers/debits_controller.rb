# -*- encoding : utf-8 -*-
class DebitsController < ApplicationController
  layout "checkout"

  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order, :only => [:new, :create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :build_cart, :only => [:new, :create]

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
        redirect_to(debit_path(response.payment), :notice => "Sucesso")
      else
        @payment.errors.add(:id, "Não foi possível realizar o pagamento.")
        respond_with(@payment)
      end
     else
      respond_with(@payment)
    end
  end

  def show
    @payment = @user.payments.find(params[:id])
  end

  private

  def assign_receipt
    if params[:debit]
      params[:debit][:receipt] = Payment::RECEIPT
    else
      params.merge!(:debit => {:receipt => Payment::RECEIPT})
    end
  end
end
