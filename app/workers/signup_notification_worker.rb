# -*- encoding : utf-8 -*-
class SignupNotificationWorker
  @queue = :mailer

  def self.perform(user_id)
    member = User.find(user_id)
    raise "The welcome message for member #{user_id} was already sent" unless member.welcome_sent_at.nil?
    if member.half_user
      mail = half_user_by_via_and_gender(member)
    elsif member.reseller
      mail = MemberMailer.reseller_welcome_email(member)
    else
      mail = MemberMailer.welcome_email(member)
    end
    mail.deliver
    member.welcome_sent_at = Time.now
    member.save
  end

  def self.half_user_by_via_and_gender member
    MemberMailer.send("welcome_#{member.registered_via_string}_half_#{member.gender_string}_user_email", member)
  end
end
