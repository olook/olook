class ValentineInviteWorker
  @queue = :mail_invite

  def self.perform(user_name, to)
    mail = ValentineInviteMailer.invite_email(user_name, to)
    mail.deliver
  end

end