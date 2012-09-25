# -*- encoding : utf-8 -*-
class SetPaymentStatusWorker
  @queue = :order_status

  def self.perform
    MoipCallback.where(:processed => false).find_each do |moip_callback|
      payment = moip_callback.try(:payment)
      payment.set_state_moip(moip_callback) if payment
    end
  end
end
