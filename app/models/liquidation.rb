class Liquidation < ActiveRecord::Base
  has_many :liquidation_products, :dependent => :destroy
  has_many :liquidation_carousels, :dependent => :destroy
  serialize :resume
  validates_presence_of :name, :description, :starts_at, :ends_at
  validates_length_of :description, :maximum => 100
  mount_uploader :welcome_banner, ImageUploader
  mount_uploader :lightbox_banner, ImageUploader
  mount_uploader :teaser_banner, ImageUploader
  mount_uploader :big_banner, ImageUploader

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

  def has_product?(product)
    return false unless resume.respond_to?(:fetch)
    resume.fetch(:products_ids, []).include?(product.id)
  end

  def in_category(category_id)
    liquidation_products.joins(:product).where(category_id: category_id, products: {is_visible: 1}).where("liquidation_products.inventory > 0")
  end

  def subcategories(category_id)
    in_category(category_id).group(:subcategory_name).order("subcategory_name asc").map { |p| [p.subcategory_name, p.subcategory_name_label] if valid_value? p.subcategory_name }.compact
  end

  def shoes
    subcategories(Category::SHOE)
  end

  def bags
    subcategories(Category::BAG)
  end

  def accessories
    subcategories(Category::ACCESSORY)
  end

  def shoe_sizes
    in_category(Category::SHOE).group(:shoe_size).order("shoe_size asc").map(&:shoe_size).compact
  end

  def heels
    in_category(Category::SHOE).group(:heel).order("heel asc").map { |p| [p.heel, p.heel_label] if valid_value? p.heel }.compact.sort{ |a,b| a[0].to_i <=> b[0].to_i }
  end

  private 
    def valid_value? value
      !value.nil? && value != '_' 
    end
end
