# == Schema Information
#
# Table name: braspag_authorize_responses
#
#  id                      :integer          not null, primary key
#  correlation_id          :string(255)
#  success                 :boolean
#  error_message           :string(255)
#  identification_code     :string(255)
#  braspag_order_id        :string(255)
#  braspag_transaction_id  :string(255)
#  amount                  :string(255)
#  payment_method          :integer
#  acquirer_transaction_id :string(255)
#  authorization_code      :string(255)
#  return_code             :string(255)
#  return_message          :string(255)
#  status                  :integer
#  credit_card_token       :string(255)
#  processed               :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  retries                 :integer          default(0)
#

class BraspagAuthorizeResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)

  STATUS = {
    0 => :authorize,
    1 => :deliver,
    2 => :cancel,
    3 => :cancel
  }

  def update_payment_status(payment)
    event = STATUS[status]
    if event.nil?
      self.update_attributes(:processed => true, :error_message => "Invalid status")
    elsif payment.set_state(event)
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
