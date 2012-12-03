# == Schema Information
#
# Table name: campaing_participants
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  gender     :boolean
#  campaing   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
