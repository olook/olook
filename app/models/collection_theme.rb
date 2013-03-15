class CollectionTheme < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :header_image, presence: true

  mount_uploader :header_image, ImageUploader

  has_one :catalog, class_name: "Catalog::CollectionTheme", foreign_key: "association_id"
  belongs_to :collection_theme_group
  accepts_nested_attributes_for :collection_theme_group, reject_if: :all_blank

  acts_as_list scope: :collection_theme_group

  after_create :generate_catalog

  scope :active, where(active: true)

  def self.find_by_slug_or_id(slug_or_id)
    self.find_by_slug(slug_or_id) || self.find_by_id(slug_or_id)
  end

  def name=(val)
    self[:slug] = val.parameterize unless val.nil?
    self[:name] = val
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

  private

  def generate_catalog
    self.build_catalog.save!
  end
end
