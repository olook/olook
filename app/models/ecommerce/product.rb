# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base

  SUBCATEGORY_TOKEN, HEEL_TOKEN = "Categoria", "Salto"
  CARE_PRODUCTS = ['Amaciante', 'Apoio plantar', 'Impermeabilizante', 'Palmilha', 'Proteção para calcanhar']
  UNAVAILABLE_ITEMS = :unavailable_items
  # TODO: Temporarily disabling paper_trail for app analysis
  #has_paper_trail :skip => [:pictures_attributes, :color_sample]
  QUANTITY_OPTIONS = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}
  MINIMUM_INVENTORY_FOR_XML = 3

  extend ProductFinder

  has_enumeration_for :category, :with => Category, :required => true

  after_create :create_master_variant
  after_update :update_master_variant

  has_many :pictures, :dependent => :destroy
  has_many :details, :dependent => :destroy
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
  has_and_belongs_to_many :highlight_campaigns

  has_many :gift_boxes_product, :dependent => :destroy
  has_many :gift_boxes, :through => :gift_boxes_product
  has_many :liquidation_products
  has_many :liquidations, :through => :liquidation_products
  has_many :catalog_products, :class_name => "Catalog::Product", :foreign_key => "product_id"
  has_many :catalogs, :through => :catalog_products

  validates :name, :presence => true
  validates :description, :presence => true
  validates :model_number, :presence => true, :uniqueness => true

  mount_uploader :color_sample, ColorSampleUploader

  scope :only_visible , where(:is_visible => true)

  scope :shoes        , where(:category => Category::SHOE)
  scope :bags         , where(:category => Category::BAG)
  scope :accessories  , where(:category => Category::ACCESSORY)

  scope :in_category, lambda { |value| { :conditions => ({ category: value } unless value.blank? || value.nil?) } }
  scope :in_collection, lambda { |value| { :conditions => ({ collection_id: value } unless value.blank? || value.nil?) } }
  scope :search, lambda { |value| { :conditions => ([ "name like ? or model_number = ?", "%#{value}%", value ] unless value.blank? || value.nil?) } }

  def self.featured_products category
    products = fetch_all_featured_products_of category
    remove_sold_out products
    # TODO => it is still missing the removal of sold out specifc variants (shoe number)
  end

  def self.valid_for_xml(products_blacklist, collections_blacklist)
    products = only_visible.joins(valid_for_xml_join_query).includes(:variants).where(valid_for_xml_where_query,
                                                                  :products_blacklist => products_blacklist ,
                                                                  :collections_blacklist => collections_blacklist).
                                                                 order("collection_id desc")
    products.delete_if { |product| product.has_inventory_less_than_minimum_for_xml? }
  end

  def self.valid_criteo_for_xml(products_blacklist, collections_blacklist)
    products = only_visible.joins(criteo_join_query).includes(:variants).where(criteo_where_query,
                                                    :products_blacklist => products_blacklist ,
                                                    :collections_blacklist => collections_blacklist ).
                                                  where("(products.category <> 1 or x.count_variants >= 3)").
                                                  order("collection_id desc")
    products.delete_if { |product| product.has_inventory_less_than_minimum_for_xml? }
  end

  def has_less_then_minimum_inventory?
    if self.shoe?
      shoe_inventory_has_less_than_minimum?
    else
      inventory < MINIMUM_INVENTORY_FOR_XML
    end
  end

  def self.in_profile profile
    !profile.blank? && !profile.nil? ? scoped.joins('inner join products_profiles on products.id = products_profiles.product_id').where('products_profiles.profile_id' => profile) : scoped
  end

  accepts_nested_attributes_for :pictures, :reject_if => lambda{|p| p[:image].blank?}

  def product_id
    id
  end

  def model_name
    category_detail = details.find_by_translation_token("Categoria")
    category_detail ? category_detail.description : ""
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
    picture = self.pictures.where(:display_on => DisplayPictureOn::GALLERY_1).first
  end

  #
  # I know, it's a weird/crazy logic. Ask Andressa =p
  #
  def backside_picture
    if cloth?
      picture = pictures.order(:display_on).second
    else
      picture = self.pictures.where(:display_on => DisplayPictureOn::GALLERY_2).first
    end
    return_catalog_or_suggestion_image(picture)
  end

  def wearing_picture
    picture = pictures.order(:display_on).last
    return_catalog_or_suggestion_image(picture)
  end

  def thumb_picture
    main_picture.try(:image_url, :thumb) # 50x50
  end

  def bag_picture
    main_picture.try(:image_url, :bag) # 70x70
  end

  def checkout_picture
    main_picture.try(:image_url, :checkout) # 90x90
  end

  def showroom_picture
    main_picture.try(:image_url, :showroom) # 170x170
  end

  def suggestion_picture
    main_picture.try(:image_url, :suggestion) # 260x260
  end

  def catalog_picture
    return_catalog_or_suggestion_image(main_picture)
  end

  def return_catalog_or_suggestion_image(picture)
    picture.try(:image_url, :catalog)
  end

  def master_variant
    @master_variant ||= Variant.unscoped.where(:product_id => self.id, :is_master => true).first
  end

  def colors(size = nil, admin = false)
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
    self.category == ::Category::CLOTH
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

  def has_inventory_less_than_minimum_for_xml?
    if self.shoe?
      shoe_inventory_has_less_than_minimum?
    elsif self.cloth?
      cloth_inventory_has_less_than_minimum?
    else
      false
    end
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
    products = Rails.cache.fetch(CACHE_KEYS[:product_clothes_for_profile][:key] % profile, :expires_in => CACHE_KEYS[:product_clothes_for_profile][:expire]) do
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

  private

    def details_relevance
      h = { "categoria" => 1, "detalhe" => 2, "metal" => 3, "salto" => 4, "material externo" => 5, "material interno" => 6, "material da sola" => 7 }

      h.default = 1.0/0.0 # infinity
      h
    end

    def self.fetch_all_featured_products_of category
      products = Rails.cache.fetch(CACHE_KEYS[:product_fetch_all_featured_products_of][:key] % category, :expires_in => CACHE_KEYS[:product_fetch_all_featured_products_of][:expire]) do
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

    def detail_by_token token
      if details.loaded?
        detail = self.details.select { |d| d.translation_token == token }.last
      else
        detail = self.details.where(:translation_token => token).last
      end
      detail.description if detail
    end

    #TODO: find a more descriptive name
    def self.criteo_join_query
      query = "INNER JOIN( "
      query += "SELECT product_id, SUM(inventory) AS \"sum_inventory\",  COUNT(id) as \"count_variants\" "
      query += "FROM variants WHERE variants.price > 0.0  GROUP BY product_id"
      query += ") AS x ON products.id = x.product_id"
    end

    #TODO: find a more descriptive name
    def self.criteo_where_query
      query = "x.sum_inventory > #{MINIMUM_INVENTORY_FOR_XML} AND products.id NOT IN (:products_blacklist) "
      query += "AND products.collection_id NOT IN (:collections_blacklist)"
    end

    #TODO: find a more descriptive name
    def self.valid_for_xml_join_query
      query = " INNER JOIN("
      query += "SELECT product_id, SUM(inventory) AS \"sum_inventory\" from variants WHERE variants.price > 0.0 GROUP BY product_id"
      query += ") AS x ON products.id = x.product_id"
    end

    #TODO: find a more descriptive name
    def self.valid_for_xml_where_query
      query = "x.sum_inventory > #{MINIMUM_INVENTORY_FOR_XML} AND products.id "
      query += "NOT IN (:products_blacklist) AND products.collection_id NOT IN (:collections_blacklist)"
    end
end

