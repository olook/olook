# -*- encoding : utf-8 -*-
class InviteObserver < ActiveRecord::Observer
  def after_create(invite)
    Resque.enqueue(MailInviteWorker, invite.id) if invite.sent_at.nil?
  end
end
