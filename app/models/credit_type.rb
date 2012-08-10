class CreditType < ActiveRecord::Base
  attr_accessor :type
  has_many :user_credits
end
