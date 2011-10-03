class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_member, :class_name => "User"
  
  validates_presence_of :user, :email
end
