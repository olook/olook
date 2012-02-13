# -*- encoding: utf-8 -*-
namespace :users do
  
  desc "Send in the card email"
  task :send_incart_emails, :needs => :environment do |task, args|
    
    conditions = UserNotifier.get_orders( "in_the_cart", -1, 2, [ "in_cart_notified = 0" ] )
    UserNotifier.send_in_cart( conditions.join(" AND ") )

  end

end

