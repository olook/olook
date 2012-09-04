# -*- encoding : utf-8 -*-
class SendInCartEmailWorker
  @queue = :send_in_cart_email

  def self.perform
    conditions = UserNotifier.get_carts( 1, 1, [ "notified = 0" ] )
    UserNotifier.send_in_cart( conditions.join(" AND ") )
  end
end
