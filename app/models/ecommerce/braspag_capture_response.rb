class BraspagCaptureResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)

  STATUS = {
    0 => :authorize,
    2 => :cancel
  }

  def update_payment_status(payment)
    event = STATUS[status] || :cancel
    if payment.set_state(event)
      self.update_attribute(:processed, true)
      if payment.order && payment.order.reload.canceled?
        Resque.enqueue(Abacos::CancelOrder, payment.order.number)
      end
    else
      self.update_attributes(
        :retries => (self.retries + 1),
        :error_message => payment.errors.full_messages.to_s
      )
    end
  end

end
