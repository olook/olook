module Payments
  class BraspagSenderStrategy
    include Payments::Logger

    FILE_DIR = "#{Rails.root}/config/braspag.yml"

    attr_accessor :cart_service, :payment, :credit_card_number, :return_code

    def initialize(payment)
      @payment = payment
      @payment_id = payment.id
      @payment_successful = false
      log("Initializing BraspagSenderStrategy [#{payment.inspect}]")
    end

    def send_to_gateway
      log("Sending transaction to gateway. Payment ID: #{ payment.try :id }")
      begin
        authorize_response = authorize
        log("Authorize Response: #{authorize_response.inspect}")
        if authorized_and_pending_capture?(authorize_response)
          Resque.enqueue_in(2.minute, Braspag::GatewaySenderWorker, payment.id)
          log("Enqueued Braspag::GatewaySenderWorker")
          @payment_successful = true
        else
          encrypt_credit_card_number
          @payment_successful = false
        end

        payment
      rescue Exception => error
        log("Error on sending payment [#{payment.id}] to Braspag")
        ErrorNotifier.send_notifier("Braspag", error, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => payment)
      ensure
        update_gateway_info
      end
    end

    def payment_successful?
      @payment_successful
    end

    def update_gateway_info
      log("Updating Gateway Info for payment")
      payment.gateway = Payment::GATEWAYS.fetch(:braspag)
      payment.gateway_response_status = Payment::SUCCESSFUL_STATUS
    end

    def process_enqueued_request
      begin
        # asure the payment will have an order.
        self.payment.reload

        log("Processing enqueued request for order #{payment.order.try(:id)}")

        authorize_response = BraspagAuthorizeResponse.find_by_identification_code(self.payment.identification_code)

        order_analysis_service = OrderAnalysisService.new(self.payment, self.credit_card_number, authorize_response)
        if order_analysis_service.should_send_to_analysis?
          log("Sending to clearsale analysis")
          clearsale_order_response = order_analysis_service.send_to_analysis
          log("Analysis response: #{clearsale_order_response}")
        else
          log("Capturing transaction")
          capture(authorize_response)
        end

      rescue Exception => error
        log("[ERROR] Error on processing enqueued request: " + error.message)
        ErrorNotifier.send_notifier("Braspag", error, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => payment)
        raise error
      ensure
        payment.encrypt_credit_card
        payment.save!
      end
    end

    def authorized_and_pending_capture?(authorize_response)
      authorize_response.success && authorize_response.status == 1
    end

    def process_capture_request
      begin
        authorize_response = BraspagAuthorizeResponse.find_by_identification_code(self.payment.identification_code)
        capture(authorize_response)
      rescue Exception => error
        log("[ERROR] Error on capturing payment: " + error)
        ErrorNotifier.send_notifier("Braspag", error, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => payment)
        raise error
      ensure
        encrypt_credit_card_number
      end
    end

    def web_service_data
      config = YAML::load(File.open(FILE_DIR))
      env = config[Rails.env]["environment"]
      Braspag::Webservice.new(env.to_sym)
    end

    def authorize
      log("Sending transaction for authorization.")
      gateway_response = web_service_data.authorize_transaction(authorize_transaction_data)
      log("Braspag::Webservice.authorize_transaction_data response: #{gateway_response.inspect}")
      process_authorize_response(gateway_response)
    end

    def capture(authorize_response)
      log("Sending to capture [AuthorizeId: #{ authorize_response.id }]")
      capture_response = web_service_data.capture_credit_card_transaction(create_capture_credit_card_request(authorize_response))
      log("Transaction capture response: #{authorize_response}")
      process_capture_response(capture_response,authorize_response)
    end

    def authorize_transaction_data
      id_code = SecureRandom.uuid
      Braspag::AuthorizeTransactionRequestBuilder.new
      .with_request_id(id_code)
      .for_order(order_data).for_customer(customer_data).with_payment_request(payment_data).build
    end

    def order_data
      Braspag::Order.new(payment.identification_code)
    end

    def address_data
      delivery_address = Address.find_by_id!(cart_service.freight[:address][:id])
      Braspag::AddressBuilder.new
        .with_street(delivery_address.street)
        .with_number(delivery_address.number)
        .with_complement(delivery_address.complement)
        .with_district(delivery_address.neighborhood)
        .with_zip_code(delivery_address.zip_code)
        .with_city(delivery_address.city)
        .with_state(delivery_address.state)
        .with_country(delivery_address.country).build
    end

    def customer_data
      Braspag::CustomerBuilder.new
      .with_customer_id(payment.user.id)
      .with_customer_name("#{ payment.user.first_name } #{ payment.user.last_name }")
      .with_customer_email(payment.user.email)
      .with_customer_address(address_data)
      .with_delivery_address(address_data).build
    end

    def payment_data
      payment_method = Payments::BraspagBankTranslator.payment_method_for payment.bank
      Braspag::CreditCardBuilder.new
      .with_payment_method(Braspag::PAYMENT_METHOD[payment_method])
      .with_amount(format_amount(payment.total_paid))
      .with_transaction_type("1")
      .with_currency("BRL")
      .with_country("BRA")
      .with_number_of_payments(payment.payments)
      .with_payment_plan(payment_plan(payment.payments))
      .with_transaction_type("1")
      .with_holder_name(payment.user_name)
      .with_card_number(self.credit_card_number)
      .with_security_code(payment.security_code)
      .with_expiration_month(payment.expiration_date[0,2])
      .with_expiration_year("20#{payment.expiration_date[3,2]}").build
    end

    def payment_plan(number_of_payments)
      if number_of_payments > 1
        "1"
      else
        "0"
      end
    end

    def format_amount(amount)
      format("%.2f", amount).gsub(',', '').gsub('.', '')
    end

    def authorize_transaction(payment_request, order, customer)
      id_code = SecureRandom.uuid
      Braspag::AuthorizeTransactionRequestBuilder.new
      .with_request_id(id_code)
      .for_order(order).for_customer(customer).with_payment_request(payment_request).build
    end

    def process_authorize_response(authorize_response)
      log("Processing the authorize response")

      authorize_transaction_result = authorize_response[:authorize_transaction_response][:authorize_transaction_result]
      if authorize_transaction_result[:success]
        update_payment_response(Payment::SUCCESSFUL_STATUS, authorize_transaction_result[:payment_data_collection][:payment_data_response][:return_message])
        create_success_authorize_response(authorize_transaction_result)
      else
        update_payment_response(Payment::FAILURE_STATUS, authorize_transaction_result[:error_report_data_collection].to_s)
        create_failure_authorize_response(authorize_transaction_result)
      end
    end

    def process_capture_response(capture_response, authorize_response)

      log("Processing the capture response #{capture_response}")

      if capture_response
        capture_transaction_result = capture_response[:capture_credit_card_transaction_response][:capture_credit_card_transaction_result]
        if capture_transaction_result[:success]
          create_capture_response(capture_response, authorize_response.identification_code) # capture_transaction_result[:order_data][:order_id])
          update_payment_response(Payment::SUCCESSFUL_STATUS, capture_transaction_result[:transaction_data_collection][:transaction_data_response][:return_message])
          log("Created capture response on database, and payment status updated to SUCCESS")
        else
          update_payment_response(Payment::FAILURE_STATUS, capture_transaction_result[:error_report_data_collection].to_s)
          log("Payment status updated to FAILURE")
        end
      else
        update_payment_response(Payment::FAILURE_STATUS, capture_transaction_result[:error_report_data_collection].to_s)
          log("Payment status updated to FAILURE")
      end
    end

    def create_capture_credit_card_request(authorize_response)
      braspag_transaction_id = authorize_response.braspag_transaction_id
      amount = authorize_response.amount
      request_id = authorize_response.correlation_id
      transaction_request = Braspag::TransactionRequest.new(braspag_transaction_id, amount)
      Braspag::CreditCardTransactionRequestBuilder.new.with_request_id(request_id).with_transaction_request(transaction_request).build
    end

    def create_success_authorize_response(authorize_transaction_result)
      authorization_response = BraspagAuthorizeResponse.new(
          {:correlation_id => authorize_transaction_result[:correlation_id],
          :success => true,
          :identification_code => authorize_transaction_result[:order_data][:order_id],
          :braspag_order_id => authorize_transaction_result[:order_data][:braspag_order_id],
          :braspag_transaction_id => authorize_transaction_result[:payment_data_collection][:payment_data_response][:braspag_transaction_id],
          :amount => authorize_transaction_result[:payment_data_collection][:payment_data_response][:amount],
          :payment_method => authorize_transaction_result[:payment_data_collection][:payment_data_response][:payment_method],
          :acquirer_transaction_id => authorize_transaction_result[:payment_data_collection][:payment_data_response][:acquirer_transaction_id],
          :authorization_code => authorize_transaction_result[:payment_data_collection][:payment_data_response][:authorization_code],
          :return_code => authorize_transaction_result[:payment_data_collection][:payment_data_response][:return_code],
          :return_message => authorize_transaction_result[:payment_data_collection][:payment_data_response][:return_message],
          :status => authorize_transaction_result[:payment_data_collection][:payment_data_response][:status],
          :credit_card_token => authorize_transaction_result[:payment_data_collection][:payment_data_response][:credit_card_token]})
      @return_code = authorization_response[:return_code]
      authorization_response.save
      authorization_response
    end

    def create_failure_authorize_response(authorize_transaction_result)
      authorization_response = BraspagAuthorizeResponse.new(
          {:correlation_id => authorize_transaction_result[:correlation_id],
          :success => false,
          :error_message => authorize_transaction_result[:error_report_data_collection].to_s,
          :identification_code => payment.identification_code})
      authorization_response.save
      authorization_response
    end

    def create_capture_response(gateway_capture_response, order_id)
      capture_transaction_result = gateway_capture_response[:capture_credit_card_transaction_response][:capture_credit_card_transaction_result]
      if capture_transaction_result[:success]
        create_success_capture_response(capture_transaction_result, order_id)
      else
        create_failure_capture_response(capture_transaction_result)
      end
    end

    def create_success_capture_response(capture_transaction_result, order_id)
      capture_response = BraspagCaptureResponse.new(
          {:correlation_id => capture_transaction_result[:correlation_id],
          :success => true,
          :identification_code => order_id,
          :braspag_transaction_id => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:braspag_transaction_id],
          :acquirer_transaction_id => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:acquirer_transaction_id],
          :amount => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:amount],
          :authorization_code => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:authorization_code],
          :return_code => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:return_code],
          :return_message => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:return_message],
          :status => capture_transaction_result[:transaction_data_collection][:transaction_data_response][:status]})
      capture_response.save
      capture_response
    end

    def create_failure_capture_response(capture_transaction_result)
      capture_response = BraspagCaptureResponse.new(
          {:correlation_id => capture_transaction_result[:correlation_id],
          :success => false,
          :error_message => capture_transaction_result[:error_report_data_collection].to_s,
          :identification_code => payment.identification_code})
      capture_response.save
      capture_response
    end

    def update_payment_response(response_status, message)
      payment.update_attributes(
          gateway_response_status: response_status,
          gateway_message: message
        )
    end

    private
      def encrypt_credit_card_number
        payment.encrypt_credit_card
        payment.save!
      end

  end
end
