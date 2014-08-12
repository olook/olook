module Api
  module V1
    class CheckoutController < ApiBasicController
      respond_to :json

      def create

        # Extrair methodo para criar pagamentos

        # TODO: criar white list para meios de pgto
        payment = current_cart.payment_method.constantize.new

        payment.receipt = Payment::RECEIPT
        payment.telephone = current_cart.address.telephone


        if payment.is_a? Debit
          payment.bank = params[:payment_data][:bank]
        elsif payment.is_a? CreditCard
          payment.credit_card_number = params[:payment_data][:number].gsub(/\s+/, "")
          payment.user_identification = params[:payment_data][:cpf]
          payment.user_name = params[:payment_data][:full_name]
          payment.security_code = params[:payment_data][:security_code]
          payment.payments = params[:payment_data][:installments]
          payment.expiration_date = params[:payment_data][:expiration_date]
          # payment.bank = params[:payment_data][:bank]
          payment.bank = "Visa"
        end

        payment.save!

        cart_service = CartProfit::CartCalculatorAdapter.new(current_cart)

        sender_strategy = case current_cart.payment_method
        when 'Billet', 'Debit'
          Payments::MoipSenderStrategy.new(cart_service, payment)
        when 'CreditCard'
          gateway = Payments::BraspagSenderStrategy.new(payment)
          gateway.cart_service = cart_service
          gateway.credit_card_number = payment.credit_card_number
          gateway
        when 'MercadoPagoPayment'
          Payments::MercadoPagoSenderStrategy.new
        end


        payment_builder = PaymentBuilder.new(
          { 
            :cart_service => cart_service, 
            :payment => payment, 
            :gateway_strategy => sender_strategy, 
            :tracking_params => session[:order_tracking_params] 
          } 
        )

        result = payment_builder.process!

        # TODO => Melhorar este tratamento de erro
        if result[:status] == Payment::FAILURE_STATUS
          render json: {}, status: 500
        else
          render json: {order_number: 4338465}, location: checkout_conclusion_path, status: :created
        end


      end

      private

      def current_cart
        @cart ||= Cart.find_saved_for_user(current_user, {session: session[:cart_id], params: params[:cart_id], coupon_code: params[:coupon_code]})
        session[:cart_id] = @cart.id if @cart
        @cart
      end      

    end
  end
end