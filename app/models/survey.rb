class Survey < ActiveRecord::Base
  has_many :questions
  validates :name, :uniqueness => true
end
