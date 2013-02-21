class BraspagAuthorizeResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)

  STATUS = {
    0 => :authorize,
    1 => :deliver,
    2 => :cancel,
    3 => :cancel
  }

  def problems_with_credit_card_validation?
    return return_code == '58'
  end

  def update_payment_status(payment)
    event = STATUS[status] || :cancel
    if event.nil?
      self.update_attributes(:processed => true, :error_message => "Invalid status")
    elsif payment.set_state(event)
      self.update_attribute(:processed, true)
      if payment.order
        Resque.enqueue_in(2.hours, Abacos::CancelOrder, payment.order.number)
      end
    else
      self.update_attributes(
        :retries => (self.retries + 1),
        :error_message => payment.errors.full_messages.to_s
      )
    end
  end

end
