class OrderStateTransition < ActiveRecord::Base
  
  belongs_to :order
  
  before_create :snapshot
  
  def snapshot
    order = self.order
    if order.state != "in_the_cart"
      self.payment_response = order.payment.payment_response.status
      self.payment_response_status = order.payment.payment_response.response_status
      self.gateway_status_reason = order.payment.gateway_status_reason
    end
  end


end
