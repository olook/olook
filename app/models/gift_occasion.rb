class GiftOccasion < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient
  belongs_to :gift_occasion_type
  
  validates_associated :user, :gift_recipient, :gift_occasion_type
  
  validates :day, :presence => true, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 32}
  validates :month, :presence => true, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 13}
end
