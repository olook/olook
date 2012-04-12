class GiftRecipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient_relation
  has_many :occasions
  belongs_to :profile
  
  validates_associated :user, :gift_recipient_relation
  
  validates :name, :presence => true, :length => {:minimum => 2}
  validates :shoe_size, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 50}, :allow_nil => true

  def self.update_profile_and_shoe_size(recipient_id, profile, shoe_size = nil)
    if recipient_id
      recipient = GiftRecipient.find_by_id(recipient_id)
      if recipient
        recipient.profile = profile if profile
        recipient.shoe_size = shoe_size if shoe_size
        recipient.save!
        recipient
      end
    end
  end
end
