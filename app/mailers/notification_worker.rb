# -*- encoding : utf-8 -*-
class NotificationWorker
  @queue = 'low'

  def self.perform opts
    DevAlertMailer.notify(opts).deliver
  end
end
