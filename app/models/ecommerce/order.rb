class Order < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true
  delegate :email, :to => :user, :prefix => true

  #this should be hard coded now
  def total
    25.90
  end
end
