# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  REASON = 'Pagamento'
  RECEIPT = 'AVista'
  STATUS = {
    "1" => :authorized,
    "2" => :started,
    "3" => :billet_printed,
    "4" => :completed,
    "5" => :canceled,
    "6" => :under_review
  }
  attr_accessor :receipt, :user_identification
  belongs_to :order
  has_one :payment_response

  def save_with(payment_url, order)
    self.url, self.order = payment_url, order
    save
  end

  def set_state(status)
    event = STATUS[status]
    send(event) if event
  end
end
