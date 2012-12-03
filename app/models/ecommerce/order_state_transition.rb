# == Schema Information
#
# Table name: order_state_transitions
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  event                      :string(255)
#  from                       :string(255)
#  to                         :string(255)
#  created_at                 :datetime
#  payment_response           :string(255)
#  payment_transaction_status :string(255)
#  gateway_status_reason      :string(255)
#

class OrderStateTransition < ActiveRecord::Base

  belongs_to :order

  before_create :snapshot

  private
    def snapshot
      #TODO: Criar snapshots para cada tipo de pagamento
      payment = self.order.erp_payment
      if payment
        self.payment_response = payment.gateway_response_status
        self.payment_transaction_status = payment.gateway_transaction_status
        self.gateway_status_reason = payment.gateway_status_reason
      end
    end
end
