# -*- encoding : utf-8 -*-
class SendBilletReminderWorker
  @queue = 'low'

  def self.perform
    BilletNotifier.send_reminder.each do | reminder |
      reminder.deliver
    end
  end
end
