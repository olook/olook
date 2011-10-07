# -*- encoding : utf-8 -*-
class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_member, :class_name => "User"
  
  validates_presence_of :user, :email
  validates_format_of :email, :with => User::EmailFormat
  
  def send_invitation
    InvitesMailer.invite_email(self.id).deliver
  end
end
