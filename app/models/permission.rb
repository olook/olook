# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  model_name  :string(255)
#  action_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Permission < ActiveRecord::Base

  has_and_belongs_to_many :roles

  validates :action_name, :uniqueness => {:scope => :model_name, :message => "for given Model exists"}

end
