# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :cart_service, :payment, :delivery_address, :response, :credit_card_number

  def initialize(cart_service, payment)
    @cart_service, @payment = cart_service, payment
  end

  def process!
    payment.cart_id = @cart_service.cart.id
    payment.save!
    ActiveRecord::Base.transaction do
      send_payment!
      create_payment_response!
      payment_response = set_payment_url!.payment_response

      if payment_response.response_status == Payment::SUCCESSFUL_STATUS
        #NAO EH A MESMA COISA !!
        if payment_response.transaction_status != Payment::CANCELED_STATUS
          
          order = cart_service.generate_order!
          payment.order = order
          payment.deliver! if payment.kind_of?(CreditCard)
          payment.save!
          
          order.line_items.each do |item|
            variant = Variant.lock("LOCK IN SHARE MODE").find(item.variant.id)
            variant.decrement!(:inventory, item.quantity)
          end
          
          total_coupon = cart_service.total_discount_by_type(:coupon)
          if total_coupon > 0
            coupon_payment = CouponPayment.create!(
              :total_paid => total_coupon, 
              :coupon_id => cart_service.coupon.id,
              :order => order)
            coupon_payment.deliver!
            coupon_payment.authorize!
          end
          #           
          #           credit_payment = CreditPayment.new(
          #             :credit_type => :loyality, 
          #             :amount_paid => cart_service.credits_for?(:loyality), 
          #             :order => order).save!
          #           credit_payment.deliver!
          #           credit_payment.authorize!
          #           

          total_credits = cart_service.total_discount_by_type(:credits)
          if total_credits > 0
            credit_payment = CreditPayment.create!(
              :credit_type_id => CreditType.find_by_code!(:invite).id, 
              :total_paid => total_credits, 
              :order => order)
            credit_payment.deliver!
            credit_payment.authorize!
          end
          #           
          #           credit_payment = CreditPayment.new(
          #             :credit_type => :reedem, 
          #             :amount_paid => cart_service.credits_for?(:reedem), 
          #             :order => order).save!
          #           credit_payment.deliver!
          #           credit_payment.authorize!
          
          respond_with_success
        else
          respond_with_failure
        end
      else
        respond_with_failure
      end
    end

    rescue Exception => error
      error_message = "Moip Request #{error.message} - Order Number #{payment.try(:order).try(:number)} - Payment Expiration #{payment.payment_expiration_date}"
      log(error_message)
      NewRelic::Agent.add_custom_parameters({:error_msg => error_message})
      Airbrake.notify(
        :error_class   => "Moip Request",
        :error_message => error_message
      )
      respond_with_failure
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
    delivery_address = Address.find_by_id!(cart_service.freight[:address_id])
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
      :tel_fixo => remove_nine_digits_of_telphone(delivery_address.telephone),
    }
    data
  end

  def payment_data
    if payment.is_a? Billet
    data = { :valor => cart_service.total, :id_proprio => payment.identification_code,
                :forma => payment.to_s, :recebimento => payment.receipt, :pagador => payer,
                :razao=> Payment::REASON, :data_vencimento => billet_expiration_date }
    elsif payment.is_a? CreditCard
      data = { :valor => cart_service.total, :id_proprio => payment.identification_code, :forma => payment.to_s,
                :instituicao => payment.bank, :numero => credit_card_number,
                :expiracao => payment.expiration_date, :codigo_seguranca => payment.security_code,
                :nome => payment.user_name, :identidade => payment.user_identification,
                :telefone => remove_nine_digits_of_telphone(payment.telephone), :data_nascimento => payment.user_birthday,
                :parcelas => payment.payments, :recebimento => payment.receipt,
                :pagador => payer, :razao => Payment::REASON }
    else
      data = { :valor => cart_service.total, :id_proprio => payment.identification_code, :forma => payment.to_s,
               :instituicao => payment.bank, :recebimento => payment.receipt, :pagador => payer,
               :razao => Payment::REASON }
    end
    data
  end

  private
  
  def remove_nine_digits_of_telphone(telphone)
    if(telphone =~ /\(11\)9\d{4}-\d{4}/)
      telphone.gsub!("(11)9","(11)")
    end
    telphone
  end

  def billet_expiration_date
    payment.payment_expiration_date.strftime("%Y-%m-%dT15:00:00.0-03:00")
  end

  def respond_with_failure
    OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
  end

  def respond_with_success
    OpenStruct.new(:status => payment.payment_response.response_status, :payment => payment)
  end

  def log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end
end
