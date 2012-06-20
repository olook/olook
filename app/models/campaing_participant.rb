class CampaingParticipant < ActiveRecord::Base
  attr_accessible :user, :user_id , :campaing
  validates_presence_of :first_name , :last_name , :email , :campaing, :user_id

  belongs_to :user

  before_validation :set_user_data!

  def set_user_data!
    self.first_name = user.first_name
    self.last_name = user.last_name
    self.email = user.email
    self.gender = user.gender
    self
  end
end
