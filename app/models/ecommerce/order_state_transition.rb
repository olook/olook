class OrderStateTransition < ActiveRecord::Base
  
  belongs_to :order
  
  before_create :snapshot

  private

  def snapshot
    payment = self.order.try(:payment)
    if payment && payment.payment_response
      self.payment_response = payment.payment_response.response_status
      self.payment_transaction_status = payment.payment_response.transaction_status
      self.gateway_status_reason = payment.gateway_status_reason
    end
  end


end
