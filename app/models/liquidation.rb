class Liquidation < ActiveRecord::Base
  has_many :liquidation_products
  has_many :liquidation_carousels
  serialize :resume
  #validates_presence_of :name, :description
  #validates_length_of :description, :maximum => 100
  mount_uploader :welcome_banner, ImageUploader
  mount_uploader :lightbox_banner, ImageUploader

  validate :validate_if_change_on_period_conflicts_existing_products

  def validate_if_change_on_period_conflicts_existing_products
    return true unless self.persisted?
    if LiquidationService.new(self.id).conflicts_existing_products?(self.starts_at, self.ends_at)
      self.errors.add(:starts_at,
       "This change conflicts with existing products on this liquidation, they cannot be part of a collection during the liquidation time"
      )
      false
    end
  end
end
