# -*- encoding : utf-8 -*-
class SendEnabledCreditsNotificationWorker
  @queue = 'low'

  def self.perform
    raise 'Deprecated Feature'

    UserNotifier.send_enabled_credits_notification.each do | reminder |
      begin
      	reminder.deliver
      rescue => e
        Airbrake.notify(
          :error_class   => "NotificationSender",
          :error_message => "SendEnabledCredits: the following error occurred: #{e.message}"
        )      	
      end
    end
  end
end
