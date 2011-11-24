# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  REASON = 'Pagamento'
  RECEIPT = 'AVista'
  attr_accessor :receipt, :user_identification
  belongs_to :order
  has_one :payment_response

  def save_with(payment_url, order)
    self.url, self.order = payment_url, order
    save
  end
end
