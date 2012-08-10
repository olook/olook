class CreditType < ActiveRecord::Base
  attr_accessor :type
  has_many :user_credits
  has_many :credits, :through => :user_credits
end
