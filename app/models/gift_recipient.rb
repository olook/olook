class GiftRecipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient_relation
  has_many :occasions
  belongs_to :profile
  
  validates_associated :user, :gift_recipient_relation
  
  validates :name, :presence => true, :length => {:minimum => 2}
  validates :shoe_size, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 50}, :allow_nil => true
  
  delegate :name, :to => :gift_recipient_relation, :allow_nil => true, :prefix => :relation
  
  def first_name
    self.name.split[0] if self.name

  def belongs_to_user?(user)
    user_id == user.try(:id)
  end
end
