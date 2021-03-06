# -*- encoding : utf-8 -*-
class Invite < ActiveRecord::Base
  STATUS = {:yes => "Sim", :no => "Não", :accepted => "Sim, mas por outro convite! ):"}
  LIMIT = 100

  belongs_to :user
  belongs_to :invited_member, :class_name => "User"

  validates_presence_of :user, :email
  validates_format_of :email, :with => User::EmailFormat
  validates_uniqueness_of :email, :scope => :user_id

  scope :unsent, where('sent_at IS NULL')
  scope :sent, where('sent_at IS NOT NULL')
  scope :accepted, where('invited_member_id IS NOT NULL')

  delegate :name, :to => :user, :prefix => 'member'
  delegate :invite_token, :to => :user, :prefix => 'member'

  after_create :send_invite_mail

  def accept_invitation(invitee)
    self.tap do |invite|
      invite.invited_member = invitee
      invite.accepted_at = Time.now
      invite.save
    end
  end

  def self.status_for_user_invite(user_id, invite)
    t = Invite.arel_table
    invites = Invite.where(t[:email].eq(invite.email).and(t[:user_id].not_eq(user_id)).and(t[:accepted_at].not_eq(nil)))
    if invites.size > 0
      STATUS[:accepted]
    elsif invite.invited_member.nil?
      STATUS[:no]
    else
      STATUS[:yes]
    end
  end

  def self.find_inviter(invitee)
    self.find_by_invited_member_id(invitee.id).try(:user)
  end

  def send_invite_mail
    Resque.enqueue(MailInviteWorker, self.id) if self.sent_at.nil?
  end
end
