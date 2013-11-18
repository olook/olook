# -*- encoding : utf-8 -*-
class Variant < ActiveRecord::Base

  has_many :freebie_variants

  default_scope where(:is_master => false)

  before_save :fill_is_master, :calculate_discount_percent
  after_save :replicate_master_changes, :if => :is_master
  after_update :update_catalog_products_inventory

  belongs_to :product

  validates :product, :presence => true
  validates :number, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :display_reference, :presence => true

  validates :price, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :inventory, :initial_inventory, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}

  validates :width , :presence => true, :numericality => {:greater_than_or_equal_to => 0.0}
  validates :height, :presence => true, :numericality => {:greater_than_or_equal_to => 0.0}
  validates :length, :presence => true, :numericality => {:greater_than_or_equal_to => 0.0}
  validates :weight, :presence => true, :numericality => {:greater_than_or_equal_to => 0.0}

  delegate :name, :to => :product
  delegate :master_variant, :to => :product
  delegate :color_name, :to => :product
  delegate :main_picture, :to => :product
  delegate :thumb_picture, :to => :product
  delegate :checkout_picture, :to => :product
  delegate :bag_picture, :to => :product
  delegate :showroom_picture, :to => :product
  delegate :promotion?, :to => :product
  delegate :gift_price, :to => :product

  def update_initial_inventory_if_needed
    if (initial_inventory == 0 || inventory > initial_inventory)
      self.initial_inventory = inventory
    end
  end

  def product_id=(param_id)
    result = super(param_id)
    copy_master_variant
    result
  end

  def sku
    "#{product.model_number}-#{number}"
  end

  def dimensions
    result = [self.width, self.height, self.length].map do |dimension|
      "%.1f" % dimension
    end.join 'x'
    result.gsub('.', I18n.t('number.format.separator')) + ' cm'
  end

  def volume
    ((self.width * self.height * self.length)/1000000).round 6 # in cubic meters
  end

  def fill_is_master
    self.is_master = false if self.is_master.nil?
  end

  def available_for_quantity?(quantity = 1)
    inventory - quantity >= 0
  end

  def copy_master_variant
    return if self.is_master?
    self.width      = master_variant.width
    self.height     = master_variant.height
    self.length     = master_variant.length
    self.weight     = master_variant.weight
    self.price      = master_variant.price
    self.inventory  = 0 if self.inventory.nil?
  end

  def replicate_master_changes
    # I don't know why, but self.product.variants doesn't work
    master_product = Product.find(self.product.id)
    master_product.variants.each do |child_variant|
      child_variant.copy_master_variant
      child_variant.save!
    end
  end

  def update_catalog_products_inventory
    Catalog::Product.where(:variant_id => self.id).update_all(:inventory => self.inventory)
  end  

  def retail_price
    retail_price_logic
  end

  def discount_percent
    discount = read_attribute(:discount_percent)
    (discount.blank? || discount.zero?) ? 0 : discount
  end

  private

  # FIXME this doesn't really work properly, since it doesn't bring the master_variant's retail_price
  def retail_price_logic
    rp = read_attribute(:retail_price)
    (rp.nil? || rp.blank? || rp.zero?) ? price : rp
  end

  def calculate_discount_percent
    return unless self.retail_price.respond_to? :>
    return unless self.price.respond_to? :>
    if self.retail_price > 0 && self.price > 0
      percent = ((self.retail_price * 100) / self.price).round
      self.discount_percent = 100 - percent
    end
  end
end
