# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  # before_filter :check_cpf, :only => [:update]
  # 
  # def update
  #   if @user.cpf.nil?
  #     @user.require_cpf = true
  #     if @user.update_attributes(:cpf => params[:user][:cpf])
  #       msg = "CPF cadastrado com sucesso"
  #     else
  #       msg = "CPF já cadastrado"
  #     end
  #   end
  #   redirect_to(payments_path, :notice => msg)
  # end

  
  before_filter :authenticate_user!
  # before_filter :assign_receipt, :only => [:create]

  def new_debit
    @payment = Debit.new
  end

  def create_debit
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

  def new_billet
    @payment = Billet.new
  end

  def create_billet
    @payment = Billet.new(params[:billet])

    if @payment.valid?
      @order = @cart.generate_order(@payment)
      insert_user_in_campaing(params[:campaing][:sign_campaing]) if params[:campaing]
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Product::UNAVAILABLE_ITEMS
        redirect_to(cart_path, :notice => "Produtos com o baixa no estoque foram removidos de sua sacola")
      elsif response.status == Payment::SUCCESSFUL_STATUS
        clean_session_order!
        redirect_to(order_billet_path(:number => @order.number), :notice => "Boleto gerado com sucesso")
      else
        respond_with(new_payment_with_error)
      end
    else
      respond_with(@payment)
    end
  end


  def new_credit_card
    @payment = CreditCard.new(CreditCard.user_data(@user))
  end

  def create_credit_card
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

  def new_payment_with_error_debit
    @payment = Debit.new(params[:debit])
    @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
    @payment
  end

  def assign_receipt_debit
    if params[:debit]
      params[:debit][:receipt] = Payment::RECEIPT
    else
      params.merge!(:debit => {:receipt => Payment::RECEIPT})
    end
  end

  def new_payment_with_error_credit_card
    @payment = CreditCard.new(params[:credit_card])
    @payment.errors.add(:id, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
    @payment
  end

  def assign_receipt_credit_card
    params[:credit_card][:receipt] = Payment::RECEIPT
  end


  def new_payment_with_error_billet
    @payment = Billet.new(params[:billet])
    @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
    @payment
  end

  def assign_receipt_billet
    params[:billet] = {:receipt => Payment::RECEIPT}
  end
end
