# -*- encoding : utf-8 -*-
class OrderAnalysisService
  include Payments::Logger

  attr_accessor :payment, :credit_card_number, :paid_at

  def initialize(payment, credit_card_number, paid_at)
    self.payment = payment
    @payment_id = payment.id
    self.credit_card_number = credit_card_number
  end

  def self.check_results(order)
    response = ClearsaleOrderResponse.new
    response.order = order

    clearsale_response = Setting.use_clearsale_server ? Clearsale::Analysis.get_order_status(order.id) : OrderAnalysisService.generate_sample_response
    response.status = clearsale_response.status
    response.score = clearsale_response.score

    if clearsale_response.status.nil?
      Airbrake.notify(Clearsale,
        :error_class   => OrderAnalysisService,
        :error_message => "Clearsale enviou um status invalido para order: #{order.id}"
      ) 
    end     

    response.save unless response.has_pending_status?

    response
  end

  def send_to_analysis
    adapter = ClearsaleOrderAdapter.new(payment, credit_card_number, paid_at)

    adapted_order, adapted_payment, adapted_user = adapter.adapt

    response = ClearsaleOrderResponse.new
    response.order =  payment.order

    clearsale_response = Setting.use_clearsale_server ? Clearsale::Analysis.send_order(adapted_order, adapted_payment, adapted_user) : OrderAnalysisService.generate_sample_response
    response.status = clearsale_response.status
    response.score = clearsale_response.score
    response.save

    if payment.set_state(:review)
      payment.save!
    end

    response
  end
 
  def should_send_to_analysis?
    log("force_clearsale? [#{Setting.force_send_to_clearsale}], send_to_clearsale? [#{Setting.send_to_clearsale}] ")
    return true if Setting.force_send_to_clearsale
    return false unless Setting.send_to_clearsale
    if payment.user.nil? || user_is_blacklisted?
      log("user [#{payment.user.email}] is blacklisted") if payment.user
      true
    else
      first_used = first_credit_card_payment?(payment.user)
      log("First use of this card ? [#{first_used}]")
      first_used
    end
  end

  def self.generate_sample_response
    sample_struct = OpenStruct.new(:status => (ClearsaleOrderResponse::PENDING_STATUS | ClearsaleOrderResponse::AUTHORIZED_STATUS | ClearsaleOrderResponse::REJECTED_STATUS).sample , :score => (0..40).to_a.sample.to_f)
    Rails.logger.debug("sample response => #{sample_struct.inspect}")
    sample_struct
  end

  private

    def user_is_blacklisted?
      blacklist = Setting.as_list(:blacklisted_users)
      blacklist.include?(payment.user.email)
    end

    def first_credit_card_payment?(user)
      credit_card_payments = CreditCard.where(user_id: user.id, state: ['authorized','completed'])
      approved_credit_card_numbers = credit_card_payments.map {|c| c.credit_card_number[-4,4] } 

      credit_card_last_numbers = payment.credit_card_number[-4,4]
      ! approved_credit_card_numbers.include?(credit_card_last_numbers)

    end

end