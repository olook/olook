# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base

  SUBCATEGORY_TOKEN, HEEL_TOKEN = "Categoria", "Salto"
  CARE_PRODUCTS = ['Amaciante', 'Apoio plantar', 'Impermeabilizante', 'Palmilha', 'Proteção para calcanhar']
  UNAVAILABLE_ITEMS = :unavailable_items
  # TODO: Temporarily disabling paper_trail for app analysis
  #has_paper_trail :skip => [:pictures_attributes, :color_sample]
  QUANTITY_OPTIONS = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}
  PRODUCT_VISIBILITY = {site: 1, olooklet: 2, all: 3}
  MINIMUM_INVENTORY_FOR_XML = 3

  extend ProductFinder

  has_enumeration_for :category, :with => Category, :required => true

  after_create :create_master_variant
  after_update :update_master_variant
  before_save :set_launch_date, if: :should_update_launch_date?

  has_many :pictures, :dependent => :destroy
  has_many :details, :dependent => :destroy
  has_many :price_logs, class_name: 'ProductPriceLog', :dependent => :destroy
  # , :conditions => {:is_master => false}
  has_many :variants, :dependent => :destroy do
    def sorted_by_description
      self.sort {|variant_a, variant_b| variant_a.description <=> variant_b.description }
    end
  end

  # has_one :master_variant, :class_name => "Variant", :conditions => {:is_master => true}, :foreign_key => "product_id"
  # has_one :main_picture, :class_name => "Picture", :conditions => {:display_on => DisplayPictureOn::GALLERY_1}, :foreign_key => "product_id"

  belongs_to :collection
  has_and_belongs_to_many :profiles
  has_and_belongs_to_many :collection_themes

  has_many :gift_boxes_product, :dependent => :destroy
  has_many :gift_boxes, :through => :gift_boxes_product
  has_many :liquidation_products
  has_many :liquidations, :through => :liquidation_products
  has_many :catalog_products, :class_name => "Catalog::Product", :foreign_key => "product_id"
  has_many :catalogs, :through => :catalog_products
  has_many :consolidated_sells, dependent: :destroy

  validates :name, :presence => true
  validates :description, :presence => true
  validates :model_number, :presence => true, :uniqueness => true

  mount_uploader :color_sample, ColorSampleUploader
  mount_uploader :picture_for_xml, XmlPictureUploader

  scope :only_visible , where(:is_visible => true)

  scope :shoes        , where(:category => Category::SHOE)
  scope :bags         , where(:category => Category::BAG)
  scope :accessories  , where(:category => Category::ACCESSORY)

  scope :in_category, lambda { |value| { :conditions => ({ category: value } unless value.blank? || value.nil?) } }
  scope :in_collection, lambda { |value| { :conditions => ({ collection_id: value } unless value.blank? || value.nil?) } }
  scope :with_brand, lambda { |value| { :conditions => ({ brand: value } unless value.blank? || value.nil?) } }
  scope :by_inventory, lambda { |value| joins(:variants).group("products.id").order("sum(variants.inventory) #{ value }") if ["asc","desc"].include?(value) }
  scope :by_sold, lambda { |value| joins(:variants).group("products.id").order("sum(variants.initial_inventory - variants.inventory) #{ value }") if ["asc","desc"].include?(value) }
  scope :with_visibility, lambda { |value| { :conditions => ({ is_visible: value } unless value.blank? || value.nil? ) } }
  scope :search, lambda { |value| { :conditions => ([ "name like ? or model_number = ?", "%#{value}%", value ] unless value.blank? || value.nil?) } }
  scope :with_pictures, ->(value) {
    if value == "not null"
      joins("left JOIN `pictures` ON `pictures`.`product_id` = `products`.`id`").where("pictures.id is NOT NULL").group("products.id") unless value.blank?
    else
      joins("left JOIN `pictures` ON `pictures`.`product_id` = `products`.`id`").where("pictures.id is NULL").group("products.id") unless value.blank?
    end
  }
  scope :in_launch_range, ->(start_date, end_date) { where("launch_date BETWEEN ? AND ?", start_date, end_date) unless start_date.blank? || end_date.blank? }
  scope :in_sections, lambda { |value| { :conditions => ({ visibility: value } unless value.blank? || value.nil? ) } }


  scope :valid_for_xml, lambda{|black_list| only_visible.where("variants.inventory >= 1").where("variants.price > 0.0").group("products.id").joins(:variants).having("(category = 1 and count(distinct variants.id) >= 4) or (category = 4 and count(distinct variants.id) >= 2) or category NOT IN (1,4) and products.id NOT IN (#{black_list})")}
  scope :valid_for_xml_without_cloth, lambda { |black_list| only_visible.where("variants.inventory >= 1").group("products.id").joins(:variants).having("(category = 1 and count(distinct variants.id) >= 4) or category NOT IN (1,4) and products.id NOT IN (#{XML_BLACKLIST["products_blacklist"].join(",")})")}

  scope :with_discount, lambda{|ordenation| Product.select("products.*, (variants.price - variants.retail_price) discount_delta").where("variants.is_master = true").where("variants.price > variants.retail_price").where("variants.retail_price > 0").group("products.id").joins(:variants).order("discount_delta #{ordenation}")}

  def self.featured_products category
    products = fetch_all_featured_products_of category
    remove_sold_out products
    # TODO => it is still missing the removal of sold out specifc variants (shoe number)
  end

  def self.in_profile profile
    !profile.blank? && !profile.nil? ? scoped.joins('inner join products_profiles on products.id = products_profiles.product_id').where('products_profiles.profile_id' => profile) : scoped
  end

  def self.in_subcategory subcategory
    subcategory.present? ? scoped.joins('inner join details on products.id = details.product_id').where('details.description' => subcategory) : scoped
  end

  accepts_nested_attributes_for :pictures, :reject_if => lambda{|p| p[:image].blank?}

  def seo_path
    formatted_name.to_s.parameterize + "-" + id.to_s
  end

  def product_id
    id
  end

  def title_text
    color = product_color == 'Não informado' ? '' : product_color
    name_with_color = "#{formatted_name(200)} #{color}"
    if name_with_color.size > 33
      "#{name_with_color}"
    else
      "#{name_with_color} - Roupas e Sapatos Femininos"
    end
  end

  def model_name
    category_detail = details.find_by_translation_token("Categoria")
    category_detail ? category_detail.description : ""
  end

  def related_products
    product_ids = RelatedProduct.select(:product_b_id).where(:product_a_id => self.id).map(&:product_b_id)
    Product.where(:id => product_ids)
  end

  def unrelated_products
    scope = Product.where("id <> :current_product", current_product: self.id)
    related_ids = related_products.map(&:id)
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
  delegate :retail_price, to: :master_variant
  delegate :'retail_price=', to: :master_variant
  delegate :width, to: :master_variant
  delegate :'width=', to: :master_variant
  delegate :height, to: :master_variant
  delegate :'height=', to: :master_variant
  delegate :length, to: :master_variant
  delegate :'length=', to: :master_variant
  delegate :weight, to: :master_variant
  delegate :'weight=', to: :master_variant
  delegate :discount_percent, to: :master_variant
  delegate :'discount_percent=', to: :master_variant

  def main_picture
    @main_picture ||=
    if self.pictures.loaded?
      self.pictures.all.find { |p| p.display_on == DisplayPictureOn::GALLERY_1 }
    else
      self.pictures.where(:display_on => DisplayPictureOn::GALLERY_1).first
    end
  end

  #
  # I know, it's a weird/crazy logic. Ask Andressa =p
  #
  def backside_picture
    return @backside_picture if @backside_picture
    if self.pictures.loaded?
      if cloth?
        pictures = self.pictures.sort{ |a,b| a.display_on <=> b.display_on }
        picture = pictures.size > 1 ? pictures[1] : pictures[0]
      else
        picture = self.pictures.all.find { |p| p.display_on == DisplayPictureOn::GALLERY_2 }
      end
    else
      if cloth?
        picture = self.pictures.order(:display_on).second
      else
        picture = self.pictures.where(:display_on => DisplayPictureOn::GALLERY_2).first
      end
    end
    @backside_picture ||= return_catalog_or_suggestion_image(picture)
  end

  def wearing_picture
    return @wearing_picture if @wearing_picture
    if self.pictures.loaded?
      picture = self.pictures.sort{ |a,b| a.display_on <=> b.display_on }.last
    else
      picture = self.pictures.order(:display_on).last
    end
    @wearing_picture = return_catalog_or_suggestion_image(picture)
  end

  def thumb_picture
    @thumb_picture ||= main_picture.try(:image_url, :thumb) # 50x50
  end

  def bag_picture
    @bag_picture ||= main_picture.try(:image_url, :bag) # 70x70
  end

  def showroom_picture
    @showroom_picture ||= main_picture.try(:image_url, :showroom) # 170x170
  end

  def catalog_picture
    @catalog_picture ||= return_catalog_or_suggestion_image(main_picture)
  end

  def return_catalog_or_suggestion_image(picture)
    picture.try(:image_url, :catalog)
  end

  def master_variant
    @master_variant ||= Variant.unscoped.where(:product_id => self.id, :is_master => true).first
  end

  def colors(size = nil, admin = false)
    @colors ||= lambda {
      Rails.cache.fetch(CACHE_KEYS[:product_colors][:key] % [id, admin], expires_in: CACHE_KEYS[:product_colors][:expire]) do
        is_visible = (admin ? [0,1] : true)
        conditions = {is_visible: is_visible, category: self.category, name: self.name}
        #conditions.merge!(variants: {description: size}) if size and self.category == Category::SHOE
        Product.select("products.*, sum(variants.inventory) as sum_inventory, if(sum(distinct variants.inventory) > 0, 1, 0) available_inventory, sum(IF(variants.description = '#{size}', variants.inventory, 0)) description_inventory")
              .joins('left outer join variants on products.id = variants.product_id')
              .where(conditions)
              .where("products.id != ?", self.id)
              .group('products.id')
              .order('description_inventory desc, sum_inventory desc, available_inventory desc')
      end
    }.call
  end

  def prioritize_by shoe_size
    h = { shoe_size => 1 }
    h.default = 1.0/0.0 # infinity
    h
  end


  def all_colors(size = nil, admin = false)
    ([self] | colors(size, admin)).sort_by {|product| product.id }
  end

  def easy_to_find_description
    "#{model_number} - #{name} - #{color_name} - #{category_humanize}"
  end

  def inventory
    if variants.loaded?
      self.variants.inject(0) { |sum, variant| sum + variant.inventory.to_i }
    else
      self.variants.sum(:inventory)
    end
  end

  def initial_inventory
    self.variants.sum(:initial_inventory)
  end

  def quantity_alredy_sold
    initial_inventory - inventory
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

  def liquidation?
    active_liquidation = LiquidationService.active
    active_liquidation.has_product?(self) if active_liquidation
  end

  def promotion?
    price != retail_price
  end

  def promotion_price
    # TODO export it to default settings
    price * BigDecimal("0.8")
  end

  def gift_price(position = 0)
    GiftDiscountService.price_for_product(self,position)
  end

  def product_url(options = {})
    params =
    {
      :host => "www.olook.com.br",
      :utm_medium => "vitrine",
      :utm_content => id
    }
    Rails.application.routes.url_helpers.product_url(self, params.merge!(options))
  end

  def subcategory
    subcategory_name
  end

  def subcategory_name
    detail_by_token SUBCATEGORY_TOKEN
  end

  def heel
    detail_by_token HEEL_TOKEN
  end

  def shoe?
    self.category == ::Category::SHOE
  end

  def cloth?
    [::Category::CLOTH, ::Category::BEACHWEAR, ::Category::LINGERIE].include?(self.category)
  end

  def bag?
    self.category == ::Category::BAG
  end

  def accessory?
    self.category == ::Category::ACCESSORY
  end

  def variant_by_size(size)
    case self.category
      when Category::SHOE then
        self.variants.where(:display_reference => "size-#{size}").first
      else
        self.variants.last
    end
  end

  def picture_at_position(position)
    self.pictures.where(:display_on => position).first
  end

  def can_supports_discount?
    Setting.checkout_suggested_product_id.to_i != self.id
  end

  def self.xml_blacklist(key)
    XML_BLACKLIST[key]
  end

  def shoe_inventory_has_less_than_minimum?
    (self.shoe? && self.variants.where("inventory >=  3").count < 3)
  end

  def cloth_inventory_has_less_than_minimum?
    self.cloth? && self.variants.collect(&:inventory).include?(0)
  end

  def add_freebie product
    variant_for_freebie = product.variants.first
    variants.each do |variant|
      FreebieVariant.create!({:variant => variant, :freebie => variant_for_freebie})
    end
  end

  def remove_freebie freebie
    variant_for_freebie = freebie.variants.first
    variants.each do |variant|
      freebie_variants_to_destroy = variant.freebie_variants.where(:freebie_id => variant_for_freebie.id)
      freebie_variants_to_destroy.each { |v| v.destroy }
    end
  end

  # Actually, this method only avoid the database if using includes(:variants)
  # i.e. eager loading variants
  def inventory_without_hiting_the_database
    variants.inject(0) {|total, variant| total += variant.inventory}
  end

  def self.fetch_products label
    find_keeping_the_order Setting.send("home_#{label}").to_s.split(",")
  end

  def find_suggested_products
    products = Product.only_visible.includes(:variants).joins(:details).where("details.description = '#{ self.subcategory }' AND collection_id <= #{ self.collection_id }").order('collection_id desc')

    Product.remove_color_variations(products)
  end

  def share_by_email( informations = { } )
    emails_to_deliver = informations[:emails_to_deliver].split(/,|;|\r|\t/).map(&:strip)
    informations.slice!(:email_from, :name_from)
    emails_to_deliver.each do |email|
      ShareProductMailer.send_share_message_for(self, informations, email)
    end
  end

  def formatted_name(size=35)
    _formated_name = cloth? || is_a_shoe_accessory? ? name : "#{model_name} #{name}"
    _formated_name = "#{_formated_name[0..size-5]}&hellip;".html_safe if _formated_name.size > size
    _formated_name
  end

  def supplier_color
    color = details.find_by_translation_token("Cor fornecedor").try(:description)
    color.blank? ? "Não informado" : color
  end

  def product_color
    product_color_name = details.find_by_translation_token("Cor produto").try(:description)
    product_color_name = self.color_name if product_color_name.blank?
    product_color_name.blank? ? "Não informado" : product_color_name
  end

  def filter_color
    color = details.find_by_translation_token("Cor filtro").try(:description)
    color.blank? ? "Não informado" : color
  end

  def self.clothes_for_profile profile
    Rails.cache.fetch(CACHE_KEYS[:product_clothes_for_profile][:key] % profile, :expires_in => CACHE_KEYS[:product_clothes_for_profile][:expire]) do
      product_ids = Setting.send("cloth_showroom_#{profile}").split(",")
      find_keeping_the_order product_ids
      # QUICK AND DIRTY. remove this pleeeeeease
      # products = Collection.active.products.where(category: Category::CLOTH).last(20)
    end
  end

  def delete_cache
    if shoe?
      shoes_sizes = self.variants.collect(&:description)
      shoes_sizes.each do |shoe_size|
        Rails.cache.delete("views/#{item_view_cache_key_for(shoe_size)}")
        Rails.cache.delete("views/#{lite_item_view_cache_key_for(shoe_size)}")
      end
    end
    Rails.cache.delete("views/#{item_view_cache_key_for}")
    Rails.cache.delete("views/#{lite_item_view_cache_key_for}")
  end

  def item_view_cache_key_for(shoe_size=nil)
    shoe? ? CACHE_KEYS[:product_item_partial_shoe][:key] % [id, shoe_size.to_s.parameterize] : CACHE_KEYS[:product_item_partial][:key] % id
  end

  def lite_item_view_cache_key_for(shoe_size=nil)
    shoe? ? CACHE_KEYS[:lite_product_item_partial_shoe][:key] % [id, shoe_size.to_s.parameterize] : CACHE_KEYS[:lite_product_item_partial][:key] % id
  end

  def brand
    if self[:brand].blank?
      self[:brand] = "OLOOK"
    else
      self[:brand]
    end
  end

  def is_a_shoe_accessory?
    Catalog::Catalog::CARE_PRODUCTS.include? self.subcategory
  end

  def sort_details_by_relevance(details)
     details.sort{|first, second| details_relevance[first.translation_token.to_s.downcase] <=> details_relevance[second.translation_token.to_s.downcase]}
  end

  def xml_picture(picture)
    picture_for_xml.try(picture).present? ? picture_for_xml.try(picture) : self.main_picture.try(:image)
  end

  def description_html
    rallow = %w{ p b i br }.map { |w| "#{w}\/?[ >]" }.join('|')
    self.description.gsub(/<\/?(?!(?:#{rallow}))[^>\/]*\/?>/, '')
  end

  def is_the_size_grid_enough?
    return true if (bag? || accessory?)
    variants = self.variants.where("inventory > 0")
    if shoe?
      variants.size >= 4
    else
      sizes = variants.collect(&:description)
      (sizes.include?("M") && variants.size >= 2) || ((sizes & %w[38 40]).any? && variants.size >= 3)
    end
  end

  def quantity_sold_per_day_in_last_week
    total_sold = self.consolidated_sells.in_last_week.inject(0) { |sum, x| sum + x.amount }
    (total_sold.to_f / 7).ceil
  end

  def coverage_of_days_to_sell
    quantity = quantity_sold_per_day_in_last_week
    if quantity > 0
      (inventory.to_f/quantity).ceil
    else
      180 # 6 months
    end
  end

  def time_in_stock
    if launch_date.blank?
      365
    else
      (Date.current - launch_date).to_i
    end
  end

  private

    def details_relevance
      h = { "categoria" => 1, "detalhe" => 2, "metal" => 3, "salto" => 4, "material externo" => 5, "material interno" => 6, "material da sola" => 7 }

      h.default = 1.0/0.0 # infinity
      h
    end

    def self.fetch_all_featured_products_of category
      Rails.cache.fetch(CACHE_KEYS[:product_fetch_all_featured_products_of][:key] % category, :expires_in => CACHE_KEYS[:product_fetch_all_featured_products_of][:expire]) do
        category_name = Category.key_for(category).to_s
        product_ids = Setting.send("featured_#{category_name}_ids").split(",")

        find_keeping_the_order product_ids
      end
    end

    def self.find_keeping_the_order product_ids
      products =  includes(:variants).where("id in (?)", product_ids).all

      sorted_products = product_ids.map do |product_id|
        products.find { |product| product.id == product_id.to_i }
      end
      sorted_products.compact
    end

    def self.remove_sold_out products
      products.select {|product| product.inventory_without_hiting_the_database > 0}
    end


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

    def should_update_launch_date?
      launch_date.nil? && is_visible_changed? && is_visible
    end

    def set_launch_date
      self.launch_date = Time.zone.now.to_date
    end

    def detail_by_token token
      if details.loaded?
        detail = self.details.select { |d| d.translation_token == token }.last
      else
        detail = self.details.where(:translation_token => token).last
      end
      detail.description if detail
    end
end

