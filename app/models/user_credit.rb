class UserCredit < ActiveRecord::Base
  belongs_to :credit_type
  belongs_to :user
end
