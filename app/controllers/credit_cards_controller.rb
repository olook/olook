# -*- encoding : utf-8 -*-
class CreditCardsController < ApplicationController
  layout "checkout"

  include Checkout
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_inventory, :only => [:create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :build_cart, :only => [:new, :create]
  before_filter :order_total, :only => [:new, :create]
  before_filter :load_promotion

  def new
    @payment = CreditCard.new(CreditCard.user_data(@user))
  end

  def create
    @payment = CreditCard.new(params[:credit_card])
    @bank = params[:credit_card][:bank]
    @installments = params[:credit_card][:payments]

    if @payment.valid?
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_session_order!
        redirect_to(order_credit_path(:number => @order.number), :notice => "Pagamento realizado com sucesso")
      else
        rollback_order
        respond_with(new_payment_with_error)
      end
    else
      respond_with(@payment)
    end
  end

  private

  def new_payment_with_error
    @payment = CreditCard.new(params[:credit_card])
    @payment.errors.add(:id, "Não foi possível realizar o pagamento.")
    @payment
  end

  def order_total
    @order_total = @order.total_with_freight
  end

  def assign_receipt
    params[:credit_card][:receipt] = Payment::RECEIPT
  end
end
