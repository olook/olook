# == Schema Information
#
# Table name: contact_informations
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ContactInformation < ActiveRecord::Base
  validates :title, :uniqueness => true
end
