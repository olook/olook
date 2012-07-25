# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :check_freight
  before_filter :check_cpf, :except => [:new, :update]

  def update
    unless Cpf.new(params[:user][:cpf]).valido?
      flash[:notice] = "CPF inválido"
      return render :new
    end
    
    if @user.cpf.nil?
      @user.require_cpf = true
      if @user.update_attributes(:cpf => params[:user][:cpf])
        msg = "CPF cadastrado com sucesso"
      else
        @user.cpf = nil
        @user.errors.clear
        msg = "CPF já cadastrado"
      end
    end
    
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

    if @payment.valid?
      @order = @cart.generate_order(@payment)
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

       if response.status == Product::UNAVAILABLE_ITEMS
         return redirect_to(cart_path, :notice => "Produtos com o baixa no estoque foram removidos de sua sacola")
       elsif response.status == Payment::SUCCESSFUL_STATUS
         clean_cart!
         return redirect_to(order_show_path(:number => @order.number), :notice => "Link de pagamento gerado com sucesso")
       else
         @payment = Debit.new(params[:debit])
         @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
         @payment
       end
    end
    
    render :new_debit
  end

  def create_billet
    params[:billet] = {:receipt => Payment::RECEIPT}
    @payment = Billet.new(params[:billet])

    if @payment.valid?
      @order = @cart.generate_order(@payment)
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Product::UNAVAILABLE_ITEMS
        return redirect_to(cart_path, :notice => "Produtos com o baixa no estoque foram removidos de sua sacola")
      elsif response.status == Payment::SUCCESSFUL_STATUS
        clean_cart!
        return redirect_to(order_show_path(:number => @order.number), :notice => "Boleto gerado com sucesso")
      else
        @payment = Billet.new(params[:billet])
        @payment.errors.add(:id, "Não foi possível realizar o pagamento. Tente novamente por favor.")
        @payment
      end
    end

    render :new_billet
  end

  def create_credit_card
    params[:credit_card][:receipt] = Payment::RECEIPT
    @payment = CreditCard.new(params[:credit_card])
    @bank = params[:credit_card][:bank]
    @installments = params[:credit_card][:payments]

    if @payment.valid?
      @order = @cart.generate_order(@payment)
      payment_builder = PaymentBuilder.new(@order, @payment)
      response = payment_builder.process!

      if response.status == Product::UNAVAILABLE_ITEMS
        return redirect_to(cart_path, :notice => "Produtos com o baixa no estoque foram removidos de sua sacola")
      elsif response.status == Payment::SUCCESSFUL_STATUS
        clean_cart!
        return redirect_to(order_show_path(:number => @order.number), :notice => "Pagamento realizado com sucesso")
      else
        @payment = CreditCard.new(params[:credit_card])
        @payment.errors.add(:id, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
        @payment
      end
    end
    
    render :new_credit_card
  end
end
