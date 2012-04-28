class GiftRecipientRelation < ActiveRecord::Base
  has_many :gift_recipients
  validates :name, :presence => true, :length => {:minimum => 2}
  default_scope :order => 'name ASC'
end
