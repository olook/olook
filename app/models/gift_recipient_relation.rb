class GiftRecipientRelation < ActiveRecord::Base
  has_many :gift_recipients
  validates :name, :presence => true, :length => {:minimum => 2}
  scope :ordered_by_name, :order => 'name ASC'
end
