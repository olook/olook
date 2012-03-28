# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base
  UNAVAILABLE_ITEMS = :unavailable_items
  has_paper_trail :skip => [:pictures_attributes, :color_sample]
  QUANTITY_OPTIONS = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}
  has_enumeration_for :category, :with => Category, :required => true

  after_create :create_master_variant
  after_update :update_master_variant

  has_many :pictures, :dependent => :destroy
  has_many :details, :dependent => :destroy
  has_many :variants, :dependent => :destroy do
    def sorted_by_description
      self.sort {|variant_a, variant_b| variant_a.description <=> variant_b.description }
    end
  end

  belongs_to :collection
  has_and_belongs_to_many :profiles

  has_many :lookbooks_products, :dependent => :destroy
  has_many :lookbooks, :through => :lookbooks_products
  has_many :liquidation_products
  has_many :liquidations, :through => :liquidation_products

  validates :name, :presence => true
  validates :description, :presence => true
  validates :model_number, :presence => true, :uniqueness => true

  mount_uploader :color_sample, ColorSampleUploader

  scope :only_visible , where(:is_visible => true)
  scope :shoes        , where(:category => Category::SHOE)
  scope :bags         , where(:category => Category::BAG)
  scope :accessories  , where(:category => Category::ACCESSORY)

  accepts_nested_attributes_for :pictures, :reject_if => lambda{|p| p[:image].blank?}

  def self.for_xml
    only_visible.joins(:variants)
    .where("variants.is_master = 1 AND variants.price > 0.0 AND products.id NOT IN (:blacklist)", :blacklist => CRITEO_CONFIG["products_blacklist"])
  end

  def related_products
    products_a = RelatedProduct.select(:product_a_id).where(:product_b_id => self.id).map(&:product_a_id)
    products_b = RelatedProduct.select(:product_b_id).where(:product_a_id => self.id).map(&:product_b_id)
    Product.where(:id => (products_a + products_b))
  end

  def unrelated_products
    scope = Product.where("id <> :current_product", current_product: self.id)
    related_ids = related_products.map &:id
    scope = scope.where("id NOT IN (:related_products)", related_products: related_products) unless related_ids.empty?
    scope
  end

  def is_related_to?(other_product)
    related_products.include? other_product
  end

  def relate_with_product(other_product)
    return other_product if is_related_to?(other_product)

    RelatedProduct.create(:product_a => self, :product_b => other_product)
  end

  def unrelate_with_product(other_product)
    if is_related_to?(other_product)
      relationship = RelatedProduct.where("((product_a_id = :current_product) AND (product_b_id = :other_product)) OR ((product_b_id = :current_product) AND (product_a_id = :other_product))",
        current_product: self.id, other_product: other_product.id).first
      relationship.destroy
    end
  end

  delegate :price, to: :master_variant
  delegate :'price=', to: :master_variant
  delegate :width, to: :master_variant
  delegate :'width=', to: :master_variant
  delegate :height, to: :master_variant
  delegate :'height=', to: :master_variant
  delegate :length, to: :master_variant
  delegate :'length=', to: :master_variant
  delegate :weight, to: :master_variant
  delegate :'weight=', to: :master_variant

  def main_picture
    picture = self.pictures.where(:display_on => DisplayPictureOn::GALLERY_1).first
  end

  def showroom_picture
    main_picture.try(:image_url, :showroom)
  end

  def thumb_picture
    main_picture.try(:image_url, :thumb)
  end

  def suggestion_picture
    main_picture.try(:image_url, :suggestion)
  end

  def master_variant
    @master_variant ||= Variant.unscoped.where(:product_id => self.id, :is_master => true).first
  end

  def colors
    self.related_products.where(:category => self.category, :name => self.name)
  end

  def all_colors
    ([self] + self.colors).sort_by {|product| product.id }
  end

  def easy_to_find_description
    "#{model_number} - #{name} - #{color_name} - #{category_humanize}"
  end

  def inventory
    self.variants.sum(:inventory)
  end

  def sold_out?
    inventory < 1
  end

  def quantity ( size )
    self.variants.each do |variant|
      if variant.description.to_i == size
        return variant.inventory.to_i
      end
    end
    return 0
  end

  def instock
    sold_out? ? "0" : "1"
  end

  def to_xml(options = {})
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(:indent => 2)
    xml.product(:id => id) do
      xml.tag!(:name, name)
      xml.tag!(:smallimage,  thumb_picture)
      xml.tag!(:bigimage,  showroom_picture)
      xml.tag!(:producturl, product_url("criteo"))
      xml.tag!(:description, description)
      xml.tag!(:price, price)
      xml.tag!(:retailprice, price)
      xml.tag!(:recommendable, '1')
      xml.tag!(:instock, instock)
      xml.tag!(:category, category)
    end
  end

  def liquidation?
    active_liquidation = LiquidationService.active
    active_liquidation.resume[:products_ids].include?(self.id) if active_liquidation
  end

  def retail_price
    LiquidationProductService.retail_price(self)
  end

  def liquidation_discount_percent
    LiquidationProductService.discount_percent(self)
  end

  def product_url(source)
    Rails.application.routes.url_helpers.product_url(self, :host => "www.olook.com.br",
                                                           :utm_source => source,
                                                           :utm_medium => "banner",
                                                           :utm_campaign => "remessaging",
                                                           :utm_content => id
                                                    )
  end

  def product_url(source)
    Rails.application.routes.url_helpers.product_url(self, :host => "www.olook.com.br",
                                                           :utm_source => source,
                                                           :utm_medium => "banner",
                                                           :utm_campaign => "remessaging",
                                                           :utm_content => id
                                                    )
  end

private
  def create_master_variant
    @master_variant = Variant.new(:is_master => true,
                                  :product => self,
                                  :number => "master#{self.model_number}",
                                  :description => 'master',
                                  :price => 0.0, :inventory => 0,
                                  :width => 0, :height => 0, :length => 0,
                                  :display_reference => 'master',
                                  :weight => 0.0 )
    @master_variant.save!
  end

  def update_master_variant
    master_variant.save!
  end
end
