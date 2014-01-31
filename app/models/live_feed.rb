class LiveFeed < ActiveRecord::Base
  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  
  attr_accessible :birthdate, :email, :firstname, :gender, :ip, :lastname, :question, :zip

  validates :firstname, presence: :true
  validates :birthdate, presence: :true 
  validates :email, presence: :true, format: {with: EmailFormat}, uniqueness: true
  validates :gender, presence: :true, inclusion: ['m', 'g']
  validates :ip, presence: :true
  validates :question, presence: :true

  validate :new_email

  def new_email
    errors.add(:email, 'Already exists') if newsletter || user
  end 

  def newsletter
    CampaignEmail.find_by_email(email)
  end

  def user
    User.find_by_email(email)
  end
end
