# -*- encoding : utf-8 -*-
class SendExpirationTomorrowWarningWorker
  @queue = 'low'

  def self.perform
    UserNotifier.send_expiration_warning(true).each do | reminder |
      begin
      	reminder.deliver
      rescue => e
        Airbrake.notify(
          :error_class   => "NotificationSender",
          :error_message => "SendExpirationTomorrowWarning: the following error occurred: #{e.message}"
        )
      end
    end
  end
end
