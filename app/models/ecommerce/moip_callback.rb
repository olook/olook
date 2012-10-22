# -*- encoding : utf-8 -*-
class MoipCallback < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment

  def update_payment_status(payment)
    ActiveRecord::Base.transaction do
      payment.update_attributes!(
        :gateway_code => self.cod_moip,
        :gateway_type   => self.tipo_pagamento,
        :gateway_status => self.status_pagamento,
        :gateway_status_reason => self.classificacao
      )
      if payment.set_state(self.status_pagamento)
        self.update_attribute(:processed, true)
        if payment.order && payment.order.reload.canceled?
          Resque.enqueue(Abacos::CancelOrder, payment.order.number)
        end
      else
        self.update_attributes(
          :retry => (self.retry + 1),
          :error => payment.errors.full_messages.to_s
        )
      end
    end
  end
end
