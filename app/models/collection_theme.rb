class CollectionTheme < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: true

  mount_uploader :header_image, ImageUploader

  has_one :catalog, class_name: "Catalog::CollectionTheme", foreign_key: "association_id"
  belongs_to :collection_theme_group
  accepts_nested_attributes_for :collection_theme_group, reject_if: :all_blank

  acts_as_list scope: :collection_theme_group

  after_create :generate_catalog

  scope :active, where(active: true)

  after_initialize :default_values

  private

  def default_values
    self["slug"] = self.name.parameterize unless self.name.nil?
  end

  def generate_catalog
    self.build_catalog.save!
  end
end
