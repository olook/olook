# -*- encoding : utf-8 -*-
class CreditCardsController < ApplicationController
  layout "checkout"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :check_cpf

  def new
    @payment = CreditCard.new(CreditCard.user_data(@user))
  end

  def create
    @payment = CreditCard.new(params[:credit_card])
    @bank = params[:credit_card][:bank]
    @installments = params[:credit_card][:payments]

    if @payment.valid?
      @order = @cart.generate_order(@payment)
      insert_user_in_campaing(params[:campaing][:sign_campaing]) if params[:campaing]
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Product::UNAVAILABLE_ITEMS
        redirect_to(cart_path, :notice => "Produtos com o baixa no estoque foram removidos de sua sacola")
      elsif response.status == Payment::SUCCESSFUL_STATUS
        clean_session_order!
        redirect_to(order_credit_path(:number => @order.number), :notice => "Pagamento realizado com sucesso")
      else
        respond_with(new_payment_with_error)
      end
    else
      respond_with(@payment)
    end
  end

  private

  def new_payment_with_error
    @payment = CreditCard.new(params[:credit_card])
    @payment.errors.add(:id, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
    @payment
  end

  # def order_total
  #   @order_total = @order.total_with_freight
  # end

  def assign_receipt
    params[:credit_card][:receipt] = Payment::RECEIPT
  end
  
  def check_freight
    redirect_to addresses_path, :notice => "Escolha seu endereço" if @cart.freight.nil?
  end
  
  def check_cpf
    redirect_to payments_path, :notice => "Informe seu CPF" unless Cpf.new(@user.cpf).valido?
  end
  
  def clean_session_order!
    session[:order] = nil
    session[:freight] = nil
    session[:delivery_address_id] = nil
  end

  def insert_user_in_campaing(campaing)
      CampaingParticipant.new(:user_id => current_user.id, :campaing => campaing).save if campaing
  end
end
