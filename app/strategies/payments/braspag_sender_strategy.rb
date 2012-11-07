module Payments
  class BraspagSenderStrategy
    FILE_DIR = "#{Rails.root}/config/braspag.yml"

    attr_accessor :cart_service, :payment, :credit_card_number, :response

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
    end

    def send_to_gateway
      gateway_response = web_service_data.authorize_transaction(authorize_transaction_data)
      process_response(gateway_response[:authorize_response], gateway_response[:capture_response])
      set_payment_gateway
      payment
    end

    def payment_successful?
      success_result?(payment.gateway_response_status)
    end

    def set_payment_gateway
      payment.gateway = Payment::GATEWAYS.fetch(:braspag)
    end

    def web_service_data
      config = YAML::load(File.open(FILE_DIR))
      env = config[Rails.env]["environment"]
      Braspag::Webservice.new(:env)
    end

    def authorize_transaction_data
      id_code = SecureRandom.uuid
      Braspag::AuthorizeTransactionRequestBuilder.new
      .with_request_id(id_code)
      .for_order(order_data).for_customer(customer_data).with_payment_request(payment_data).build
    end

    def order_data
      Braspag::Order.new(@payment.identification_code)
    end

    def address_data
      Braspag::AddressBuilder.new
      .with_street(@payment.order.freight.address.street)
      .with_number(@payment.order.freight.address.number)
      .with_complement(@payment.order.freight.address.complement)
      .with_district(@payment.order.freight.address.neighborhood)
      .with_zip_code(@payment.order.freight.address.zip_code)
      .with_city(@payment.order.freight.address.city)
      .with_state(@payment.order.freight.address.state)
      .with_country(@payment.order.freight.address.country).build
    end

    def customer_data
      Braspag::CustomerBuilder.new
      .with_customer_id(@payment.user.id)
      .with_customer_name("#{ @payment.user.first_name } #{ @payment.user.last_name }")
      .with_customer_email(@payment.user.email)
      .with_customer_address(address_data)
      .with_delivery_address(address_data).build
    end

    def payment_data
      payment_method = BraspagBankTranslator.payment_method_for @payment.bank

      Braspag::CreditCardBuilder.new
      .with_payment_method(payment_method)
      .with_amount(payment.total_paid.to_s)
      .with_transaction_type("1")
      .with_currency("BRL")
      .with_country("BRA")
      .with_number_of_payments(payment.payments)
      .with_payment_plan("0")
      .with_transaction_type("1")
      .with_holder_name(payment.user_name)
      .with_card_number(payment.credit_card_number)
      .with_security_code(payment.security_code)
      .with_expiration_month(payment.expiration_date[0,2])
      .with_expiration_year("20#{payment.expiration_date[3,2]}").build
    end

    def authorize_transaction(payment_request, order, customer)
      id_code = SecureRandom.uuid
      Braspag::AuthorizeTransactionRequestBuilder.new
      .with_request_id(id_code)
      .for_order(order).for_customer(customer).with_payment_request(payment_request).build
    end

    def process_response(authorize_response, capture_response)
      authorize_transaction_result = authorize_response[:authorize_transaction_response][:authorize_transaction_result]

      if success_result?(authorize_transaction_result[:success])
        create_success_authorize_response(authorize_transaction_result)
        update_payment_response(authorize_transaction_result[:success], authorize_transaction_result[:payment_data_collection][:payment_data_response][:return_message])
      else
        create_failure_authorize_response(authorize_transaction_result)
        update_payment_response(authorize_transaction_result[:success], authorize_transaction_result[:error_report_data_collection].to_s)
      end
    end

    def success_result?(gateway_response_status)
      gateway_response_status.upcase == "TRUE"
    end

    def create_success_authorize_response(authorize_transaction_result)
      authorization_response = BraspagAuthorizeResponse.new(
          {:correlation_id => authorize_transaction_result[:correlation_id],
          :success => true,
          :order_id => authorize_transaction_result[:order_data][:order_id],
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
      authorization_response.save
      authorization_response
    end

    def create_failure_authorize_response(authorize_transaction_result)
      authorization_response = BraspagAuthorizeResponse.new(
          {:correlation_id => authorize_transaction_result[:correlation_id],
          :success => false,
          :error_message => authorize_transaction_result[:error_report_data_collection].to_s})
      authorization_response.save
      authorization_response
    end

    def update_payment_response(response_status, message)
      payment.update_attributes(
          gateway_response_status: response_status,
          gateway_message: message
        )
    end
  end

end
