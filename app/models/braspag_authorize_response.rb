class BraspagAuthorizeResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)

  STATUS = {
    0 => :authorize,
    1 => :deliver,
    2 => :cancel,
    3 => :cancel
  }

  def update_payment_status(payment)
      event = STATUS[status.to_s]
      if event.nil?
        self.update_attributes(:processed => true, :error_message => "Invalid status")
      elsif payment.set_state(event)
        self.update_attribute(:processed, true)
        if payment.order && payment.order.reload.canceled?
          Resque.enqueue(Abacos::CancelOrder, payment.order.number)
        end
      else
        self.update_attributes(
          :retry => (self.retry + 1),
          :error_message => payment.errors.full_messages.to_s
        )
      end
  end
end
