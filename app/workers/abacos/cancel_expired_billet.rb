# -*- encoding : utf-8 -*-
module Abacos
  class CancelExpiredBillet
    @queue = :cancel_old_billets

    def self.perform
      errors = []
      default_expiration_date = 2.business_day.ago
      billets = Billet.to_expire(default_expiration_date)
      billets.each do |billet|
        begin
          Abacos::CancelOrder.perform billet.order.number if billet.order
        rescue => e
          errors << "Pedido: #{billet.try(:order)}, mensagem: #{e.message}"
        end
      end
      mail = DevAlertMailer.notify_about_cancelled_billets(billets, errors)
      mail.deliver
    end
  end
end

