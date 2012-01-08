# -*- encoding : utf-8 -*-
class BilletsController < ApplicationController
  layout "checkout"

  include Checkout
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_inventory, :only => [:create]
  before_filter :check_freight, :only => [:new, :create]
  before_filter :build_cart, :only => [:new, :create]
  before_filter :load_promotion
  before_filter :assign_receipt, :only => [:create]

  def new
    @payment = Billet.new
  end

  def create
    @payment = Billet.new(params[:billet])
    if @payment.valid?
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_session_order!
        redirect_to(order_billet_path(:number => @order.number), :notice => "Boleto gerado com sucesso")
      else
        respond_with(new_payment_with_error)
      end
    else
      respond_with(@payment)
    end
  end

  private

  def new_payment_with_error
    @payment = Billet.new(params[:billet])
    @payment.errors.add(:id, "Não foi possível realizar o pagamento.")
    @payment
  end

  def assign_receipt
    params[:billet] = {:receipt => Payment::RECEIPT}
  end
end
