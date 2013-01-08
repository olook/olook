# -*- encoding : utf-8 -*-
class Checkout::CheckoutController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
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
    @payment = CreditCard.new
    @payment.telephone = session[:user_telephone_number] if session[:user_telephone_number]
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
      moip_sender_strategy = Payments::MoipSenderStrategy.new(@cart_service, @payment)
      payment_builder = PaymentBuilder.new({ :cart_service => @cart_service, :payment => @payment, :gateway_strategy => moip_sender_strategy, :tracking_params => session[:order_tracking_params] } )
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
         clean_cart!
         return redirect_to(order_show_path(:number => response.payment.order.number), :notice => "Link de pagamento gerado com sucesso")
       else
         @payment = Debit.new(params[:debit])
         @payment.user_identification = @user.cpf
         @payment.errors.add(:base, "Não foi possível realizar o pagamento. Tente novamente por favor.")
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
      moip_sender_strategy = Payments::MoipSenderStrategy.new(@cart_service, @payment)
      payment_builder = PaymentBuilder.new({ :cart_service => @cart_service, :payment => @payment, :gateway_strategy => moip_sender_strategy, :tracking_params => session[:order_tracking_params] } )
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_cart!
        return redirect_to(order_show_path(:number => response.payment.order.number))
      else
        @payment = Billet.new(params[:billet])
        @payment.user_identification = @user.cpf
        @payment.errors.add(:base, "Não foi possível realizar o pagamento. Tente novamente por favor.")
        @payment
      end
    end

    render :new_billet
  end

  def create_credit_card
    params[:credit_card][:receipt] = Payment::RECEIPT if params[:credit_card]
    @payment = CreditCard.new(params[:credit_card])
    @payment.telephone = session[:user_telephone_number] || current_user.addresses.first.telephone
    @bank = params[:credit_card][:bank] if params[:credit_card]
    @installments = params[:credit_card][:payments] if params[:credit_card]
    if @payment.valid?
      sender_strategy = PaymentService.create_sender_strategy(@cart_service, @payment)
      sender_strategy.credit_card_number =  params[:credit_card][:credit_card_number]
      payment_builder = PaymentBuilder.new({ :cart_service => @cart_service, :payment => @payment, :gateway_strategy => sender_strategy, :tracking_params => session[:order_tracking_params] } )
      response = payment_builder.process!

      if response.status == Payment::SUCCESSFUL_STATUS
        clean_cart!
        return redirect_to(order_show_path(:number => response.payment.order.number))
      else
        @payment = CreditCard.new(params[:credit_card])
        @payment.telephone = session[:user_telephone_number] || current_user.addresses.first.telephone
        @payment.user_identification = @user.cpf
        @payment.errors.add(:base, "Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
        @payment
      end
    end

    render :new_credit_card
  end
end
