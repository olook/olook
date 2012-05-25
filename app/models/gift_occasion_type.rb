class GiftOccasionType < ActiveRecord::Base
  has_many :gift_occasions
  belongs_to :gift_recipient_relation
  validates :name, :presence => true, :length => {:minimum => 2}
  scope :ordered_by_name, :order => 'name ASC'
  
  delegate :name, :to => :gift_recipient_relation, :allow_nil => true, :prefix => true
  
  def date
    "#{self.day}/#{self.month}" if self.day and self.month
  end
end
