# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :check_freight
  before_filter :check_cpf, :except => [:new, :update]

  def update
    cpf = params[:user][:cpf] if params[:user]
    msg = "CPF inválido"
    
    if !@user.cpf.blank?
      msg = "CPF já cadastrado"
    else
      @user.require_cpf = true
      @user.cpf = cpf
      msg = "CPF cadastrado com sucesso" if @user.save
    end
    
    @user.errors.clear
    
    flash[:notice] = msg
    render :new
  end

  def new
    #TODO: RENDER CREDIT CARD IF HAS CPF
  end

  def new_debit
    @payment = Debit.new
  end
  
  def new_billet
    @payment = Billet.new
  end
  
  def new_credit_card
    @payment = CreditCard.new(CreditCard.user_data(@user))
  end

  def create_debit
    if params[:debit]
      params[:debit][:receipt] = Payment::RECEIPT
    else
      params.merge!(:debit => {:receipt => Payment::RECEIPT})
    end
    
    @payment = Debit.new(params[:debit])
    @payment.user_identification = @user.cpf

    if @payment.valid?
      payment_builder = PaymentBuilder.new(@cart_service, @payment)
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
         clean_cart!
         return redirect_to(order_show_path(:number => response.payment.order.number), :notice => "Link de pagamento gerado com sucesso")
       else
         @payment = Debit.new(params[:debit])
         @payment.user_identification = @user.cpf
         @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
         @payment
       end
    end
    
    render :new_debit
  end

  def create_billet
    params[:billet] = {:receipt => Payment::RECEIPT}
    @payment = Billet.new(params[:billet])
    @payment.user_identification = @user.cpf

    if @payment.valid?
      payment_builder = PaymentBuilder.new(@cart_service, @payment)
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_cart!
        return redirect_to(order_show_path(:number => response.payment.order.number), :notice => "Boleto gerado com sucesso")
      else
        @payment = Billet.new(params[:billet])
        @payment.user_identification = @user.cpf
        @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
        @payment
      end
    end

    render :new_billet
  end

  def create_credit_card
    params[:credit_card][:receipt] = Payment::RECEIPT if params[:credit_card]
    @payment = CreditCard.new(params[:credit_card])
    @bank = params[:credit_card][:bank] if params[:credit_card]
    @installments = params[:credit_card][:payments] if params[:credit_card]
    @payment.user_identification = @user.cpf

    if @payment.valid?
      payment_builder = PaymentBuilder.new(@cart_service, @payment)
      payment_builder.credit_card_number = params[:credit_card][:credit_card_number]
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_cart!
        return redirect_to(order_show_path(:number => response.payment.order.number), :notice => "Pagamento realizado com sucesso")
      else
        @payment = CreditCard.new(params[:credit_card])
        @payment.user_identification = @user.cpf
        @payment.errors.add(:id, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
        @payment
      end
    end
    
    render :new_credit_card
  end
end
