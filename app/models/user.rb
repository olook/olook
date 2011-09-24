class User < ActiveRecord::Base
  has_many :points
  has_many :profiles, :through => :points

end
