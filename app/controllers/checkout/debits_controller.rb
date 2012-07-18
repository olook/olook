# -*- encoding : utf-8 -*-
class Checkout::DebitsController < ApplicationController
  layout "checkout"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :check_freight, :only => [:new, :create]
  before_filter :assign_receipt, :only => [:create]
  before_filter :check_cpf

  def new
    @payment = Debit.new
  end

  def create
    @payment = Debit.new(params[:debit])

    if @payment.valid?
      @order = @cart.generate_order(@payment)
      insert_user_in_campaing(params[:campaing][:sign_campaing]) if params[:campaing]
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

       if response.status == Product::UNAVAILABLE_ITEMS
         redirect_to(cart_path, :notice => "Produtos com o baixa no estoque foram removidos de sua sacola")
       elsif response.status == Payment::SUCCESSFUL_STATUS
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
    @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
    @payment
  end

  def assign_receipt
    if params[:debit]
      params[:debit][:receipt] = Payment::RECEIPT
    else
      params.merge!(:debit => {:receipt => Payment::RECEIPT})
    end
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
