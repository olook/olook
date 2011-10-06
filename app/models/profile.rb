class Profile < ActiveRecord::Base
  has_many :points
  has_many :users, :through => :points
  has_many :weights
  has_many :answers, :through => :weights
end
