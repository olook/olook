# -*- encoding : utf-8 -*-
class SendEnabledCreditsNotificationWorker
  @queue = :notification_sender

  def self.perform
    UserNotifier.send_enabled_credits_notification.each do | reminder |
      reminder.deliver
    end
  end
end
