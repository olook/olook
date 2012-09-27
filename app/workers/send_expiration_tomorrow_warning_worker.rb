# -*- encoding : utf-8 -*-
class SendExpirationTomorrowWarningWorker
  @queue = :notification_sender

  def self.perform
    UserNotifier.send_expiration_warning(true).each do | reminder |
      reminder.deliver
    end
  end
end