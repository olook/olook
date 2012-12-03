# == Schema Information
#
# Table name: braspag_capture_responses
#
#  id                      :integer          not null, primary key
#  correlation_id          :integer
#  success                 :boolean
#  processed               :boolean          default(FALSE)
#  error_message           :string(255)
#  braspag_transaction_id  :string(255)
#  acquirer_transaction_id :string(255)
#  amount                  :string(255)
#  authorization_code      :string(255)
#  return_code             :string(255)
#  return_message          :string(255)
#  status                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  identification_code     :string(255)
#  retries                 :integer          default(0)
#

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
