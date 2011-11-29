# -*- encoding : utf-8 -*-
class SignupNotificationWorker
  @queue = :mailer

  def self.perform(user_id)
    member = User.find(user_id)
    raise "The welcome message for member #{user_id} was already sent" unless member.welcome_sent_at.nil?

    mail = MemberMailer.welcome_email(member)

    mail.deliver
    
    member.welcome_sent_at = Time.now
    member.save
  end
end
