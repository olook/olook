# -*- encoding : utf-8 -*-
module Braspag
  class GatewaySenderWorker
    @queue = :order_status
    attr_accessor :payment, :address

    def self.perform(payment_id)
      self.payment = CreditCard.find(payment_id)
      self.address = payment.order.freight.address

      process_enqueued_request
    end

    def process_enqueued_request
      begin
        gateway_response = web_service_data.checkout(authorize_transaction_data)
        process_response(gateway_response[:authorize_response], gateway_response[:capture_response])
      rescue Exception => error
        ErrorNotifier.send_notifier("Braspag", error.message, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
      end
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
      Braspag::Order.new(payment.identification_code)
    end

    def address_data
      delivery_address = address
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
      .with_payment_plan("0")
      .with_transaction_type("1")
      .with_holder_name(payment.user_name)
      .with_card_number(payment.credit_card_number)
      .with_security_code(payment.security_code)
      .with_expiration_month(payment.expiration_date[0,2])
      .with_expiration_year("20#{payment.expiration_date[3,2]}").build
    end

    def format_amount(amount)
      amount.to_s.gsub(',', '').gsub('.', '')
    end

    def authorize_transaction(payment_request, order, customer)
      id_code = SecureRandom.uuid
      Braspag::AuthorizeTransactionRequestBuilder.new
      .with_request_id(id_code)
      .for_order(order).for_customer(customer).with_payment_request(payment_request).build
    end

    def process_response(authorize_response, capture_response)
      authorize_transaction_result = authorize_response[:authorize_transaction_response][:authorize_transaction_result]
      if authorize_transaction_result[:success]
        create_success_authorize_response(authorize_transaction_result)
        create_capture_response(capture_response, authorize_transaction_result[:order_data][:order_id]) if capture_response    
        update_payment_response(Payment::SUCCESSFUL_STATUS, authorize_transaction_result[:payment_data_collection][:payment_data_response][:return_message])
      else
        create_failure_authorize_response(authorize_transaction_result)
        update_payment_response(Payment::FAILURE_STATUS, authorize_transaction_result[:error_report_data_collection].to_s)
      end
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
          :error_message => capture_transaction_result[:error_report_data_collection].to_s})
      capture_response.save
      capture_response
    end

    def update_payment_response(response_status, message)
      payment.update_attributes(
          gateway_response_status: response_status,
          gateway_message: message
        )
    end
  end
end
