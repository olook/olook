# -*- encoding : utf-8 -*-
class SendInCartEmailWorker
  @queue = :send_in_cart_email

  def self.perform
    conditions = UserNotifier.get_carts( 1, 1, [ "notified = 0" ] )
    file_lines = UserNotifier.send_in_cart( conditions.join(" AND ") )

    File.open("#{Rails.root}/tmp/abandono.csv", 'w') do |file|
      file_lines.each{|fl| file.puts fl}  
    end  

  end
end
