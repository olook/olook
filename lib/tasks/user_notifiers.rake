# -*- encoding: utf-8 -*-
namespace :users do
  
  desc "Update the order status"
  task :send_incart_emails, :needs => :environment do |task, args|
    
    orders = UserNotifier.get_orders( "in_the_cart", -1, 1, [ "in_cart_notified = 0" ] )
    orders.each do |order|

  		InCartMailer.send_in_cart_mail( orders[0] ).deliver

    end

  end

end

