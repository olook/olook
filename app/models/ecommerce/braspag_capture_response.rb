class BraspagCaptureResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)

  STATUS = {
    0 => :authorize,
    2 => :cancel
  }

  def update_payment_status(payment)
    ActiveRecord::Base.transaction do
      payment.update_attributes!(
        :gateway_code => self.acquirer_transaction_id,
        :gateway_transaction_code   => self.authorization_code,
        :gateway_message => self.return_message,
        :gateway_return_code => self.return_code
      )
      event = STATUS[status] || :cancel
      if payment.set_state(event)
        self.update_attribute(:processed, true)
        if payment.order && payment.order.reload.can_be_canceled?
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

end
