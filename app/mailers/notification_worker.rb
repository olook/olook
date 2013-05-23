# -*- encoding : utf-8 -*-
class NotificationWorker
  @queue = :mailer

  def self.perform opts
    DevAlertMailer.notify(opts).deliver
  end
end