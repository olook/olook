class Moment < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: true

  mount_uploader :header_image, ImageUploader
  
  has_one :catalog, class_name: "Catalog::Moment", foreign_key: "association_id"

  after_create :generate_catalog

  scope :active, where(active: true)
  
  private
  
  def generate_catalog
    self.build_catalog.save!
  end
end