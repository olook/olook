# -*- encoding : utf-8 -*-
class ValentineInviteWorker
  @queue = :mail_invite
	
  def self.perform(user_name, to)
	 mail = InviteMailer.valentine_invite_email(user_name, to)
	 mail.deliver
  end

end