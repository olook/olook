# -*- encoding : utf-8 -*-
class OrderAnalysisService

  attr_accessor :payment, :credit_card_number, :paid_at

  def initialize(payment, credit_card_number, paid_at)
    self.payment = payment
    self.credit_card_number = credit_card_number
  end

  def self.check_results(order)
    clearsale_response = Clearsale::Analysis.get_order_status(order.id)
    response = ClearsaleOrderResponse.new
    response.order = order
    response.status = clearsale_response.status
    response.score = clearsale_response.score
    response.save unless response.has_to_be_processed?
    response
  end

  def send_to_analysis
    adapter = ClearsaleOrderAdapter.new(payment, credit_card_number, paid_at)

    adapted_order, adapted_payment, adapted_user = adapter.adapt

    clearsale_response = Clearsale::Analysis.send_order(adapted_order, adapted_payment, adapted_user)
    response = ClearsaleOrderResponse.new
    response.order =  payment.order
    response.status = clearsale_response.status
    response.score = clearsale_response.score
    response.save
    response
  end
 
  def should_send_to_analysis?
    # payment.user.orders.where(:state => Order::AUTHORIZED_STATES).empty?
    true && Setting.send_to_clearsale
  end

end