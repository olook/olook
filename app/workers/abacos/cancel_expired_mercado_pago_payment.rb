# -*- encoding : utf-8 -*-
module Abacos
  class CancelExpiredMercadoPagoPayment
    @queue = 'calhau'

    def self.perform
      MercadoPagoPayment.to_expire.each do |mp_payment|
        Abacos::CancelOrder.perform mp_payment.order.number
        MP.cancel_payment mp_payment.mercado_pago_id
      end
    end
  end
end
