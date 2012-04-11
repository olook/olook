class GiftRecipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient_relation
  has_many :occasions
  
  validates_associated :user, :gift_recipient_relation
  
  validates :name, :presence => true, :length => {:minimum => 2}
  validates :shoe_size, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 50}, :allow_nil => true
end
