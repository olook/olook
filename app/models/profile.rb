class Profile < ActiveRecord::Base
  has_many :answers
  has_many :users

end
