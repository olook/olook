class Order < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true
  delegate :email, :to => :user, :prefix => true
end
