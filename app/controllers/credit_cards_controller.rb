# -*- encoding : utf-8 -*-
class CreditCardsController < ApplicationController
  layout "checkout"

  include Ecommerce
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order, :only => [:new, :create]
  before_filter :check_inventory, :only => [:create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :build_cart, :only => [:new, :create]

  def new
    @payment = CreditCard.new
  end

  def create
    @payment = CreditCard.new(params[:credit_card])

    if @payment.valid?
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_session_order!
        redirect_to(payment_path(response.payment), :notice => "Sucesso")
      else
        @order.generate_identification_code
        @payment.errors.add(:id, "Não foi possível realizar o pagamento")
        respond_with(@payment)
      end
    else
      respond_with(@payment)
    end
  end

  def show
    @payment = @user.payments.find(params[:id])
    @payment_response = @payment.payment_response
  end

  private

  def assign_receipt
    params[:credit_card][:receipt] = Payment::RECEIPT
  end
end
