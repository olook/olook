# -*- encoding : utf-8 -*-
class SendExpirationWarningWorker
  @queue = 'low'

  def self.perform
    raise "Deprecated Feature"
    UserNotifier.send_expiration_warning.each do | reminder |
      begin
      	reminder.deliver
      rescue => e
        Airbrake.notify(
          :error_class   => "NotificationSender",
          :error_message => "SendExpirationWarning: the following error occurred: #{e.message}"
        )      	
      end
    end
  end
end
