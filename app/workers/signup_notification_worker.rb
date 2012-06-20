# -*- encoding : utf-8 -*-
class SignupNotificationWorker
  @queue = :mailer

  def self.perform(user_id)
    member = User.find(user_id)
    raise "The welcome message for member #{user_id} was already sent" unless member.welcome_sent_at.nil?
    if member.half_user
      if member.registered_via? :gift
        if member.male?
          mail = MemberMailer.welcome_gift_half_male_user_email(member)
        elsif member.female?
          mail = MemberMailer.welcome_gift_half_female_user_email(member)
        end
      elsif member.registered_via? :thin
        if member.male?
          mail = MemberMailer.welcome_thin_half_male_user_email(member)
        elsif member.female?
          mail = MemberMailer.welcome_thin_half_female_user_email(member)
        end
      end
    else
      mail = MemberMailer.welcome_email(member)
    end
    mail.deliver
    member.welcome_sent_at = Time.now
    member.save
  end
end
