module Payments
  class BraspagSenderStrategy

    attr_accessor :cart_service, :payment, :credit_card_number, :response

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
    end

    def send_to_gateway
      ##TODO call braspag gem and set response
      payment
    end

    def order_data
      Braspag::Order.new(@payment.identification_code)
    end

    def address_data(address)
      Braspag::AddressBuilder.new
      .with_street(address.street)
      .with_number(address.number)
      .with_complement(address.complement)
      .with_district(address.neighborhood)
      .with_zip_code(address.zip_code)
      .with_city(address.city)
      .with_state(address.state)
      .with_country(address.country).build
    end

    def customer_data(user, address)
      Braspag::CustomerBuilder.new
      .with_customer_id(user.id)
      .with_customer_name("#{ user.first_name } #{ user.last_name }")
      .with_customer_email(user.email)
      .with_customer_address(address_data(address))
      .with_delivery_address(address_data(address)).build
    end

    def payment_data
      Braspag::CreditCardBuilder.new
      .with_payment_method(Braspag::PAYMENT_METHOD[:braspag])
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

    def proccess_response(authorize_response, capture_response)
      authorize_transaction_result = authorize_response[:authorize_transaction_response][:authorize_transaction_result]
      
      if success_result?(authorize_transaction_result)
        create_success_authorize_response(authorize_transaction_result)
      else
        create_failure_authorize_response(authorize_transaction_result)
      end
    end

    def success_result?(transaction_result)
      transaction_result[:success].upcase == "TRUE"
    end

    def create_success_authorize_response(authorize_transaction_result)
      authorization_response = AuthorizeResponse.new(
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
          :transaction_status => authorize_transaction_result[:payment_data_collection][:payment_data_response][:status],
          :credit_card_token => authorize_transaction_result[:payment_data_collection][:payment_data_response][:credit_card_token]})
      authorization_response.save
      authorization_response
    end

    def create_failure_authorize_response(authorize_transaction_result)
      authorization_response = AuthorizeResponse.new(
          {:correlation_id => authorize_transaction_result[:correlation_id],
          :success => false,
          :error_message => authorize_transaction_result[:error_report_data_collection].to_s})
      authorization_response.save
      authorization_response
    end

  end

end
