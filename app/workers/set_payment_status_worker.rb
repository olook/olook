# -*- encoding : utf-8 -*-
class SetPaymentStatusWorker
  @queue = :order_status

  def self.perform
    MoipCallback.where(:processed => false).find_each do |moip_callback|
      payment = moip_callback.payment
      if payment
        payment.set_state_moip(moip_callback)
      else
        moip_callback.update_attributes(
          processed: true,
          error: "Pagamento não identificado."
        )
      end
    end
  end
end
