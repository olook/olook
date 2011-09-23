class Profile < ActiveRecord::Base
  has_many :answers
  has_many :user_profiles
  has_many :users, :through => :user_profiles

end
