# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :order, :payment, :delivery_address, :response

  def initialize(order, payment)
    @order, @payment = order, payment
  end

  def process!
    send_payment
    create_successful_payment_response
    payment_response = save_payment.payment_response

    if payment_response.response_status == Payment::SUCCESSFUL_STATUS
      order.decrement_inventory_for_each_item
      send_order_request_notification
    end

    OpenStruct.new(:status => payment_response.response_status, :payment => payment)
    rescue Exception => error
      Airbrake.notify(
        :error_class   => "Moip Request",
        :error_message => "Moip : #{error.message}"
      )
      log(error.message)
      OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
  end

  def send_order_request_notification
    Resque.enqueue(OrderStatusWorker, order.id)
  end

  def save_payment
    set_url_and_order_to_payment
    payment.save
    payment
  end

  def set_url_and_order_to_payment
    payment.url, payment.order = payment_url, order
  end

  def send_payment
    @response = MoIP::Client.checkout(payment_data)
  end

  def payment_url
    MoIP::Client.moip_page(response["Token"])
  end

  def create_successful_payment_response
    payment_response = payment.build_payment_response
    payment_response.build_attributes response
    payment_response.save
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
                :razao=> Payment::REASON, :dias_expiracao => Billet::EXPIRATION_DAYS }
    elsif payment.is_a? CreditCard
      data = { :valor => order_total, :id_proprio => order.identification_code, :forma => payment.to_s,
                :instituicao => payment.bank, :numero => payment.credit_card_number,
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

  def log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end

  def order_total
    order.total_with_freight
  end
end
