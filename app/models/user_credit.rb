class UserCredit < ActiveRecord::Base
  belongs_to :credit_type
  belongs_to :user
  has_many :credits
  
  def total
    credit_type.total(self)
  end
end
