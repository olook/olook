# -*- encoding : utf-8 -*-
class SendBilletReminderWorker
  @queue = :send_billet_reminder

  def self.perform
    BilletNotifier.send_reminder.each do | reminder |
      reminder.deliver
    end
  end
end
