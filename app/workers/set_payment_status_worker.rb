# -*- encoding : utf-8 -*-
class SetPaymentStatusWorker
  @queue = :order_status

  def self.perform
    
    #PEGAR TODOS CALLBACKS QUE NAO ESTAO DONE
    
    if payment
      payment.update_attributes!(:gateway_code   => params["cod_moip"],
                              :gateway_type   => params["tipo_pagamento"],
                              :gateway_status => params["status_pagamento"],
                              :gateway_status_reason => Iconv.conv('UTF-8//IGNORE', "US-ASCII", params["classificacao"]))

       Resque.enqueue_in(1.minute, SetPaymentStatusWorker, payment.id, params["status_pagamento"])
    end
    
    
    
    payment = Payment.find(payment_id.to_s)
    if payment.set_state(state.to_s) && payment.save!
      order = payment.order
      Resque.enqueue(Abacos::CancelOrder, order.number) if order && order.reload.canceled?
    else
      msg = "Erro ao mudar status do pagamento"
    end
    
    
  end
end
