class CollectionTheme < ActiveRecord::Base
  attr_accessible :product_associate_ids, :name, :slug, :video_link, :header_image_alt, :text_color, :active, :header_image, :position, :collection_theme_group_id
  attr_accessor :product_associate_ids
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :header_image, presence: true

  mount_uploader :header_image, ImageUploader

  has_one :catalog, class_name: "Catalog::CollectionTheme", foreign_key: "association_id"
  belongs_to :collection_theme_group
  accepts_nested_attributes_for :collection_theme_group, reject_if: :all_blank
  has_and_belongs_to_many :products

  acts_as_list scope: :collection_theme_group

  after_create :generate_catalog

  scope :active, where(active: true)

  def self.find_by_slug_or_id(slug_or_id)
    self.find_by_slug(slug_or_id) || self.find_by_id(slug_or_id)
  end

  def name=(val)
    self[:slug] ||= val.parameterize unless val.nil?
    self[:name] = val
  end

  def slug
    self[:slug] || self[:name].to_s.parameterize
  end

  def to_params
    slug
  end

  def video_id
    @video_id ||=
    begin
      /(?:embed\/|v=)(?<vid>[^&?]*)/ =~ video_link.to_s
      vid
    end
  end

  def video_options
    @video_options ||=
    begin
      opt_query = video_link.to_s.split('?').last
      options = opt_query.to_s.split('&').inject({}) do |h, i|
        k, v = i.split('=')
        h[k] = v
        h
      end
      options.delete('v')
      options
    end
  end

  def associate_ids
   ids_array = self.product_associate_ids.split(/[^a-zA-Z0-9]/)
   self.products = ids_array
  end

  private

  def generate_catalog
    self.build_catalog.save!
  end
end
