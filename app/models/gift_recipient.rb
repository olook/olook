class GiftRecipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient_relation
  
  validates_associated :user, :gift_recipient_relation
  
  validates :name, :presence => true, :length => {:minimum => 2}
  validates :shoe_size, :presence => true, :numericality => true
  
  validates_uniqueness_of :facebook_uid, :scope => :user_id, :allow_nil => true
end
