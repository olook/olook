# -*- encoding : utf-8 -*-
module Abacos
  class CancelExpiredBillet
    @queue = :cancel_old_billets

    def self.perform
      billets = Billet.to_expire
      billets.each do |billet|
        Abacos::CancelOrder.perform billet.order.number if billet.order
      end
      mail = DevAlertMailer.notify_about_cancelled_billets billets
      mail.deliver
    end
  end
end

