module Api
  module V1
    class CheckoutController < ApiBasicController
      respond_to :json

      def create
        payment = create_payment
        sender_strategy = create_sender_strategy(payment)
        payment_builder = create_payment_builder(payment, sender_strategy)

        result = payment_builder.process!

        # TODO => Melhorar este tratamento de erro
        if result[:status] == Payment::FAILURE_STATUS
          message = error_message_for(result, payment)  
          render json: {message: message}, status: :bad_request
        else
          session[:cart_id] = nil
          render json: {}, location: checkout_conclusion_path, status: :created
        end
      end

      private

      def current_cart
        @cart ||= Cart.find_saved_for_user(current_user, {session: session[:cart_id], params: params[:cart_id], coupon_code: params[:coupon_code]})
        session[:cart_id] = @cart.id if @cart
        @cart
      end

      def create_payment
        # TODO: criar white list para meios de pgto
        payment = current_cart.payment_method.constantize.new

        payment.receipt = Payment::RECEIPT
        payment.telephone = current_cart.address.telephone

        if payment.is_a? Debit
          payment.bank = params[:payment_data][:bank]
        elsif payment.is_a? CreditCard
          payment.credit_card_number = current_cart.payment_data[:number].gsub(/\s+/, "")
          payment.user_identification = current_cart.payment_data[:cpf]
          payment.user_name = current_cart.payment_data[:full_name]
          payment.security_code = current_cart.payment_data[:security_code]
          payment.payments = current_cart.payment_data[:installments]
          payment.expiration_date = current_cart.payment_data[:expiration_date]
          payment.bank = current_cart.payment_data[:bank]
        end

        payment.save!
        payment
      end

      def create_sender_strategy(payment)
        case current_cart.payment_method
        when 'Billet', 'Debit'
          Payments::MoipSenderStrategy.new(cart_service, payment)
        when 'CreditCard'
          gateway = Payments::BraspagSenderStrategy.new(payment)
          gateway.cart_service = cart_service
          gateway.credit_card_number = payment.credit_card_number
          gateway
        when 'MercadoPagoPayment'
          Payments::MercadoPagoSenderStrategy.new(cart_service, payment)
        end        
      end

      def create_payment_builder(payment, sender_strategy)
        PaymentBuilder.new(
          { 
            :cart_service => cart_service, 
            :payment => payment, 
            :gateway_strategy => sender_strategy, 
            :tracking_params => session[:order_tracking_params] 
          } 
        )        
      end

      def cart_service
        @cart_service ||= CartProfit::CartCalculatorAdapter.new(current_cart)        
      end

      def error_message_for response, payment
        return "Identificamos um problema com a forma de pagamento escolhida." unless payment.is_a? CreditCard 

        if response.error_code == "BP07"
          error_message = "Tempo de retorno da operadora de cartão excedido.<br>Tente novamente ou escolha outra forma de pagamento."
        else
          error_message = "Identificamos um problema com o cartão.<br>Confira os dados ou tente outra forma de pagamento."
        end
        error_message  
      end

    end
  end
end