# -*- encoding : utf-8 -*-
class SendExpirationDiscountWorker
  @queue = :expiration_discount

  def self.perform
    UserNotifier.reminder_expiration_discount.each do | reminder |
      begin
      	reminder.deliver
      rescue => e
        Airbrake.notify(
          :error_class   => "NotificationSender",
          :error_message => "SendExpirationDiscount: the following error occurred: #{e.message}"
        )
      end
    end
  end
end

