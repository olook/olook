class CollectionTheme < ActiveRecord::Base
  attr_accessible :product_associate_ids, :product_associate_ids_file, :name, :slug, :video_link, :header_image_alt, :text_color, :active, :header_image, :position, :collection_theme_group_id, :fail_product_ids
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

  def product_associate_ids= value
    @product_associate_ids = value
    ids_array = value.split(/\D/).compact
    products_hash = sanitize_products(ids_array)
    self.product_ids = products_hash.fetch(:successful)
  end

  def product_associate_ids_file= file
    ids_array = file.tempfile.read.split(/\D/).compact
    errors.add(:product_associate_ids_file, "bla not fount #{ids_array}")
    #self.product_ids = ids_array
  end


  def sanitize_products ids
    products_hash = {not_found: [], not_inventory: [], not_visible: [], successful: []}
    ids.each do |id|
      product = Product.find_by_id(id)
      case
      when product.nil?
        products_hash[:not_found] << id
      when !product.is_visible?
        products_hash[:not_visible] << product.id
      when product.inventory.zero?
        products_hash[:not_inventory] << product.id
      else
        products_hash[:successful] << product.id
      end
    end
    products_hash
  end

  private

    def generate_catalog
      self.build_catalog.save!
    end
end
