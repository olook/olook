# -*- encoding : utf-8 -*-
class ProcessPaymentsCallbacksWorker
  @queue = :order_status

  def self.perform
    MoipCallback.where(:processed => false).order(:id).find_each do |moip_callback|
      payment = Payment.find_by_identification_code(moip_callback.id_transacao)
      if payment
        #payment.set_state_moip(moip_callback)
        moip_callback.update_payment_status(payment)
      els
        moip_callback.update_attributes(
          processed: true,
          error: "Pagamento não identificado."
        )
      end
    end
  end
end
