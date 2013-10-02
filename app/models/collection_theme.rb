class CollectionTheme < ActiveRecord::Base
  attr_accessible :product_associate_ids, :product_associate_ids_file, :name, :slug, :video_link, :header_image_alt, :text_color, :active, :header_image, :position, :collection_theme_group_id, :fail_product_ids, :seo_text
  attr_reader :product_associate_ids, :product_associate_ids_file
  attr_accessor :fail_product_ids

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

  def title_text
    text = name
    text = "#{name} - #{seo_text}" unless seo_text.blank?
    "#{text} | Olook"
  end

  def name=(val)
    self[:slug] ||= val.parameterize unless val.nil?
    self[:name] = val
  end

  def slug
    self[:slug] || self[:name].to_s.parameterize
  end

  def search_name
    ActiveSupport::Inflector.transliterate(name.downcase).gsub('.', ' ')
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

  def product_associate_ids= ids
    ids_array = ids.split(/\D/).compact
    self.products = Product.where(id: ids_array).all
  end

  def product_associate_ids_file= file
    self.product_associate_ids = file.read
  end

  private

    def generate_catalog
      self.build_catalog.save!
    end
end
