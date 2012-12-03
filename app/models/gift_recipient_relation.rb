# == Schema Information
#
# Table name: gift_recipient_relations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GiftRecipientRelation < ActiveRecord::Base
  has_many :gift_recipients
  validates :name, :presence => true, :length => {:minimum => 2}
  scope :ordered_by_name, :order => 'name ASC'
end
