# == Schema Information
#
# Table name: moip_callbacks
#
#  id               :integer          not null, primary key
#  order_id         :integer
#  id_transacao     :string(255)
#  cod_moip         :string(255)
#  tipo_pagamento   :string(255)
#  status_pagamento :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  classificacao    :string(255)
#  payment_id       :integer
#  processed        :boolean          default(FALSE)
#  retry            :integer          default(0)
#  error            :text
#

# -*- encoding : utf-8 -*-
class MoipCallback < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment

  STATUS = {
    "1" => :authorize,
    "2" => :start,
    "3" => :deliver,
    "4" => :complete,
    "5" => :cancel,
    "6" => :review,
    "7" => :reverse,
    "9" => :refund
  }

  def update_payment_status(payment)
    ActiveRecord::Base.transaction do
      payment.update_attributes!(
        :gateway_code => self.cod_moip,
        :gateway_type   => self.tipo_pagamento,
        :gateway_status => self.status_pagamento,
        :gateway_status_reason => self.classificacao
      )
      event = STATUS[self.status_pagamento.to_s]
      if event.nil?
        self.update_attributes(:processed => true, :error => "Invalid status")
      elsif payment.set_state(event)
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
