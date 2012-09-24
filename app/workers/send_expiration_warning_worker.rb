# -*- encoding : utf-8 -*-
class SendExpirationWarningWorker
  @queue = :notification_sender

  def self.perform
    UserNotifier.send_expiration_warning.each do | reminder |
      reminder.deliver
    end
  end
end
