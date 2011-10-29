# -*- encoding : utf-8 -*-
class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_member, :class_name => "User"
  
  validates_presence_of :user, :email
  validates_format_of :email, :with => User::EmailFormat
  
  scope :unsent, where('sent_at IS NULL')
  scope :sent, where('sent_at IS NOT NULL')
  scope :accepted, where('invited_member_id IS NOT NULL')

  delegate :name, :to => :user, :prefix => 'member'
  delegate :invite_token, :to => :user, :prefix => 'member'

  def send_invitation
    InvitesMailer.invite_email(self.id).deliver
  end
  
  def accept_invitation(accepting_member)
    self.tap do |invite|
      invite.invited_member = accepting_member
      invite.accepted_at = Time.now
      invite.save
    end
  end
end
