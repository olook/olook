class ContactInformation < ActiveRecord::Base
  validates :title, :uniqueness => true
end
