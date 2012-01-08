# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :order, :payment, :delivery_address, :response, :credit_card_number

  def initialize(order, payment)
    @order, @payment = order, payment
    @credit_card_number = payment.credit_card_number
  end

  def process!(send_notification = true)
    ActiveRecord::Base.transaction do
      set_payment_order!
      send_payment!
      create_payment_response!
      payment_response = set_payment_url!.payment_response

      if payment_response.response_status == Payment::SUCCESSFUL_STATUS
        if payment_response.transaction_status != Payment::CANCELED_STATUS
          order.decrement_inventory_for_each_item
          order.waiting_payment!
          order.invalidate_coupon
          respond_with_success(payment)
        else
          respond_with_failure
        end
      else
        respond_with_failure
      end
    end

    rescue Exception => error
      error_message = "Moip Request #{error.message} - Order Number #{order.number} - Payment ID #{payment.id}"
      Airbrake.notify(
        :error_class   => "Moip Request",
        :error_message => error_message
      )
      log(error_message)
      respond_with_failure
  end

  def set_payment_order!
    payment.order = order
    payment.save!
    payment
  end

  def set_payment_url!
    payment.url = payment_url
    payment.save!
    payment
  end

  def send_payment!
    @response = MoIP::Client.checkout(payment_data)
  end

  def payment_url
    MoIP::Client.moip_page(response["Token"])
  end

  def create_payment_response!
    payment_response = payment.build_payment_response
    payment_response.build_attributes response
    payment_response.save!
  end

  def payer
    delivery_address = order.freight.address
    data = {
      :nome => order.user_name,
      :email => order.user_email,
      :identidade => payment.user_identification,
      :logradouro => delivery_address.street,
      :complemento => delivery_address.complement,
      :numero => delivery_address.number,
      :bairro => delivery_address.neighborhood,
      :cidade => delivery_address.city,
      :estado => delivery_address.state,
      :pais => delivery_address.country,
      :cep => delivery_address.zip_code,
      :tel_fixo => delivery_address.telephone,
    }
    data
  end

  def payment_data
    if payment.is_a? Billet
    data = { :valor => order_total, :id_proprio => order.identification_code,
                :forma => payment.to_s, :recebimento => payment.receipt, :pagador => payer,
                :razao=> Payment::REASON, :dias_expiracao => Billet::EXPIRATION_IN_DAYS }
    elsif payment.is_a? CreditCard
      data = { :valor => order_total, :id_proprio => order.identification_code, :forma => payment.to_s,
                :instituicao => payment.bank, :numero => credit_card_number,
                :expiracao => payment.expiration_date, :codigo_seguranca => payment.security_code,
                :nome => payment.user_name, :identidade => payment.user_identification,
                :telefone => payment.telephone, :data_nascimento => payment.user_birthday,
                :parcelas => payment.payments, :recebimento => payment.receipt,
                :pagador => payer, :razao => Payment::REASON }
    else
      data = { :valor => order_total, :id_proprio => order.identification_code, :forma => payment.to_s,
               :instituicao => payment.bank, :recebimento => payment.receipt, :pagador => payer,
               :razao => Payment::REASON }
    end
    data
  end

  private

  def respond_with_failure
    order.generate_identification_code
    order.payment.destroy if order.payment
    OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
  end

  def respond_with_success(payment)
    OpenStruct.new(:status => payment.payment_response.response_status, :payment => payment)
  end

  def log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end

  def order_total
    order.total_with_freight
  end
end
