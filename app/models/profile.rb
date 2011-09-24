class Profile < ActiveRecord::Base
  has_many :answers
  has_many :points
  has_many :users, :through => :points

end
