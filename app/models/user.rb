class User < ActiveRecord::Base
  has_many :user_profiles
  has_many :profiles, :through => :user_profiles
  has_many :points

end
