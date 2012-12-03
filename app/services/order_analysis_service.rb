# -*- encoding : utf-8 -*-
class OrderAnalysisService

  attr_accessor :payment, :credit_card_number, :paid_at

  def initialize(payment, credit_card_number, paid_at)
    self.payment = payment
    self.credit_card_number = credit_card_number
  end

  def self.check_results(order)
    response = ClearsaleOrderResponse.new
    response.order = order

    clearsale_response = Setting.use_clearsale_server ? Clearsale::Analysis.get_order_status(order.id) : OrderAnalysisService.generate_sample_response
    response.status = clearsale_response.status
    response.score = clearsale_response.score
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
    return true if Setting.force_send_to_clearsale
    return false unless Setting.send_to_clearsale
    return true if payment.user.nil?

    return previous_credit_card_payments.empty?
  end

  def self.generate_sample_response
    sample_struct = OpenStruct.new(:status => (ClearsaleOrderResponse::STATES_TO_BE_PROCESSED | ClearsaleOrderResponse::AUTHORIZED_STATUS | ClearsaleOrderResponse::REJECTED_STATUS).sample , :score => (0..40).to_a.sample.to_f)
    Rails.logger.debug("sample response => #{sample_struct.inspect}")
    sample_struct
  end

  private

    def previous_credit_card_payments
      user_payments = []
      payment.user.orders.each do |order| 
        user_payments << order.payments.select { |pmts| pmts.id != payment.id && pmts.is_a?(CreditCard)}
      end
      user_payments.flatten
    end

end