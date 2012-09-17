# -*- encoding : utf-8 -*-
class SetPaymentStatusWorker
  @queue = :order_status

  def self.perform(payment_id, state)
    payment = Payment.find(payment_id.to_s)
    if payment.set_state(state.to_s) && payment.save!
      order = payment.order
      Resque.enqueue(Abacos::CancelOrder, order.number) if order && order.reload.canceled?
    else
      msg = "Erro ao mudar status do pagamento"
      Airbrake.notify(:error_class => "Payment", :error_message => msg, :parameters => {:payment_id => payment_id, :state => state})
      raise msg
    end
  end
end
