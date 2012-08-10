class UserCredit < ActiveRecord::Base
  belongs_to :credit_type
  belongs_to :user
  has_many :credits
  
  def total date = DateTime.now
    credit_type.total(self, date)
  end
end
