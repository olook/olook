# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :order, :payment, :delivery_address, :response

  def initialize(order, payment, delivery_address)
    @order, @payment, @delivery_address = order, payment, delivery_address
  end

  def process!
    send_payment
    create_payment_response
    save_payment
  end

  def save_payment
    set_url_and_order_to_payment
    payment.save
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

  def create_payment_response
    payment_response = payment.build_payment_response
    payment_response.build_attributes response
    payment_response.save
  end

  def payer
    { :nome => order.user_name,
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
      :tel_cel => '(11)9976-8679' #we need check if this field is required
    }
  end

  def payment_data
    billet = { :valor => order.total, :id_proprio => order.id,
                :forma => payment.to_s, :pagador => payer,
                :razao=> Payment::REASON }

    credit = { :valor => order.total, :id_proprio => order.id, :forma => payment.to_s,
                :instituicao => payment.bank, :numero => payment.credit_card_number,
                :expiracao => payment.expiration_date, :codigo_seguranca => payment.security_code,
                :nome => payment.user_name, :identidade => payment.user_identification,
                :telefone => payment.telephone, :data_nascimento => payment.user_birthday,
                :parcelas => payment.payments, :recebimento => payment.receipt,
                :pagador => payer, :razao => Payment::REASON }

     debit = { :valor => order.total, :id_proprio => order.id, :forma => payment.to_s,
               :instituicao => payment.bank, :pagador => payer,
               :razao => Payment::REASON }

     data = case payment.payment_type
       when Payment::TYPE[:billet] then billet
       when Payment::TYPE[:debit]  then debit
       else credit
     end
  end
end
