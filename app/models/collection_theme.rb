class CollectionTheme < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: true

  acts_as_list

  mount_uploader :header_image, ImageUploader

  has_one :catalog, class_name: "Catalog::CollectionTheme", foreign_key: "association_id"
  belongs_to :collection_theme_group

  after_create :generate_catalog

  scope :active, where(active: true)

  private

  def generate_catalog
    self.build_catalog.save!
  end
end
