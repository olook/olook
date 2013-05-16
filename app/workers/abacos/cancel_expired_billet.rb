# -*- encoding : utf-8 -*-
module Abacos
  class CancelExpiredBillet
    @queue = :cancel_old_billets

    def self.perform
      Billet.to_expire.each do |billet|
        Abacos::CancelOrder.perform billet.order.number
      end
      mail = DevAlertMailer.notify_about_cancelled_billets
      mail.deliver
    end
  end
end

