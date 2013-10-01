class LiveFeed < ActiveRecord::Base
  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  
  attr_accessible :birthdate, :email, :firstname, :gender, :ip, :lastname, :question, :zip

  validates :firstname, presence: :true
  validates :birthdate, presence: :true 
  validates :email, presence: :true, format: {with: EmailFormat}, uniqueness: true
  validates :gender, presence: :true, inclusion: ['m', 'g']
  validates :ip, presence: :true
  validates :question, presence: :true
end
