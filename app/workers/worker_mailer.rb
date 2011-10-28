# -*- encoding : utf-8 -*-
class WorkerMailer
  @queue = :mailer

  def self.perform(user_id)
    mailer = NotificationsMailer.new
    mailer.signup(user_id)
  end
end

