class GiftOccasion < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient
  belongs_to :gift_occasion_type
  
  validates_associated :user, :gift_recipient, :gift_occasion_type
  
  # validates_presence_of :day
  # validates_presence_of :month
  # validates_numericality_of :day
  # validates_numericality_of :month
  validates :day, :month, :presence => true, :numericality => true
end
