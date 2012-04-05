class GiftRecipientRelation < ActiveRecord::Base
  has_many :gift_recipients
  validates :name, :presence => true
end
