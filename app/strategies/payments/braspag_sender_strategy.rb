module Payments
  class BraspagSenderStrategy
    FILE_DIR = "#{Rails.root}/config/braspag_env.yml"

    attr_accessor :cart_service, :payment, :credit_card_number, :response

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
    end

    def web_service_data
      config = YAML::load(File.open(FILE_DIR))
      env = config[Rails.env]["environment"]
      Braspag::Webservice.new(:env)
    end

    def send_to_gateway(request)
      ##TODO call braspag gem and set response
      self.authorize_transaction(request)
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


  end

  end
end
