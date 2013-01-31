module Payments
  class MoipSenderStrategy

    attr_accessor :cart_service, :payment, :credit_card_number, :response

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
    end

    def send_to_gateway
      begin
        self.response = MoIP::Client.checkout(payment_data)
        payment.build_response self.response
        save_payment_url!
        payment
      rescue Exception => error
        ErrorNotifier.send_notifier("Moip", error.message, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
      ensure
        set_payment_gateway
        payment.encrypt_credit_card if payment.is_a? CreditCard
        payment.save!
      end
    end

    def payment_successful?
        payment.gateway_response_status == Payment::SUCCESSFUL_STATUS && payment.gateway_transaction_status != Payment::CANCELED_STATUS
    end

    def save_payment_url!
      payment.url = payment_url
    end

    def set_payment_gateway
      payment.gateway = Payment::GATEWAYS.fetch(:moip)
    end

    def payment_data
      if payment.is_a? Billet
        data = { :valor => payment.total_paid, :id_proprio => payment.identification_code,
                 :forma => payment.to_s, :recebimento => payment.receipt, :pagador => payer,
                 :razao=> Payment::REASON, :data_vencimento => billet_expiration_date }
      elsif payment.is_a? CreditCard
        data = { :valor => payment.total_paid, :id_proprio => payment.identification_code, :forma => payment.to_s,
                 :instituicao => payment.bank, :numero => credit_card_number,
                 :expiracao => payment.expiration_date, :codigo_seguranca => payment.security_code,
                 :nome => payment.user_name, :identidade => payment.user_identification,
                 :telefone => format_telephone(payment.telephone), :data_nascimento => payment.user_birthday,
                 :parcelas => payment.payments, :recebimento => payment.receipt,
                 :pagador => payer, :razao => Payment::REASON }
      else
        data = { :valor => payment.total_paid, :id_proprio => payment.identification_code, :forma => payment.to_s,
                 :instituicao => payment.bank, :recebimento => payment.receipt, :pagador => payer,
                 :razao => Payment::REASON }
      end
      data
    end

    def payer
      delivery_address = Address.find_by_id!(cart_service.freight[:address][:id])
      data = {
        :nome => cart_service.cart.user.name,
        :email => cart_service.cart.user.email,
        :identidade => payment.user_identification,
        :logradouro => delivery_address.street,
        :complemento => delivery_address.complement,
        :numero => delivery_address.number,
        :bairro => delivery_address.neighborhood,
        :cidade => delivery_address.city,
        :estado => delivery_address.state,
        :pais => delivery_address.country,
        :cep => delivery_address.zip_code,
        :tel_fixo => format_telephone(delivery_address.telephone) || format_telephone(delivery_address.mobile),
        :tel_cel => delivery_address.mobile
      }
      data
    end

    def billet_expiration_date
      payment.payment_expiration_date.strftime("%Y-%m-%dT15:00:00.0-03:00")
    end

    def payment_url
      MoIP::Client.moip_page(self.response["Token"])
    end

    def format_telephone(phone_number)
      return false if phone_number.blank?
      phone_number = remove_nine_digits_of_telephone(phone_number)
      phone_number = fix_telephone_mask(phone_number)
      phone_number
    end

    def remove_nine_digits_of_telephone(phone_number)
      phone_number.gsub!("(11)9","(11)") if phone_number =~ /^\(11\)9\d{4}-\d{4}$/
      phone_number
    end

    def fix_telephone_mask(phone_number)
      if phone_number =~ /^\(11\)\d{5}-\d{3}$/
        phone_number.gsub!("-", "")
        phone_number.insert 8, "-"
      end
      phone_number
    end

  end
end
