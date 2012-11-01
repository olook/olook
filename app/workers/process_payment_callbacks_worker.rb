# -*- encoding : utf-8 -*-
class ProcessPaymentCallbacksWorker
  @queue = :order_status

  def self.perform
    moip_process
  end

  def moip_process
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

  def braspag_process

  end

end
