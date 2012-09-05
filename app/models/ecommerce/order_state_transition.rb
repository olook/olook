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
