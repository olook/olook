class ValentineInviteWorker
  @queue = :valentine_invite

  def self.perform(user, to)
    mail = ValentineInviteMailer.invite_email(user, to)
    mail.deliver
  end

end