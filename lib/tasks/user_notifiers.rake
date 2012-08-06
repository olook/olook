# -*- encoding: utf-8 -*-
namespace :users do

  desc "Send in the card email"
  task :send_incart_emails => :environment do |task, args|

    conditions = UserNotifier.get_carts( 1, 1, [ "notified = 0" ] )
    UserNotifier.send_in_cart( conditions.join(" AND ") )

  end

end

