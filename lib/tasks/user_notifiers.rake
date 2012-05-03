# -*- encoding: utf-8 -*-
namespace :users do
  
  desc "Send in the card email"
  task :send_incart_emails => :environment do |task, args|
    
    conditions = UserNotifier.get_orders( "in_the_cart", 1, 1, [ "in_cart_notified = 0" ] )
    UserNotifier.send_in_cart( conditions.join(" AND ") )
    conditions = UserNotifier.get_orders( "in_the_cart", 3, 1 )
    UserNotifier.delete_old_orders( conditions.join(" AND ") )

  end

end

