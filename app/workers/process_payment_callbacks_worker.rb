# -*- encoding : utf-8 -*-
class ProcessPaymentCallbacksWorker
  @queue = 'low'

  def self.perform
    MoipCallback.where(:processed => false).order(:id).find_each do |moip_callback|
      payment = Payment.find_by_identification_code(moip_callback.id_transacao)
      if payment
        moip_callback.update_payment_status(payment)
      else
        moip_callback.update_attributes(
          processed: true,
          error: "Pagamento não identificado."
        )
      end
    end
  end

end
