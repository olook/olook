class GiftRecipientRelation < ActiveRecord::Base
  validates :name, :presence => true
end
