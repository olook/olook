# encoding: utf-8
class Catalog::Catalog < ActiveRecord::Base
  CLOTH_SIZES_TABLE = {"PP" => 1, "P" =>2, "M" => 3, "G" => 4, "GG" => 5,
                 "34" => 6, "36" => 7, "38" => 8, "40" => 9, "42" => 10, "44" => 11, "46" => 12,
                 "Único" => 13}

  has_many :products, :class_name => "Catalog::Product", :foreign_key => "catalog_id"

  validates :type, :presence => true, :exclusion => ["Catalog::Catalog"]

  CARE_PRODUCTS = ['Amaciante', 'Apoio plantar', 'Impermeabilizante', 'Palmilha', 'Proteção para calcanhar']

  def in_category(category_id)
    # @liquidation = LiquidationService.active
    @query = products.joins(:product)
    # @query = @query.joins('left outer join liquidation_products on liquidation_products.product_id = catalog_products.product_id') if @liquidation
    @query = @query.where(category_id: category_id, products: {is_visible: 1}).where("catalog_products.inventory > 0")

    # @query = @query.where(liquidation_products: {product_id: nil}) if @liquidation
    @query
  end

  def subcategories(category_id)
    in_category(category_id).group(:subcategory_name).order("subcategory_name asc").map { |p| [p.subcategory_name, p.subcategory_name_label]}.compact
  end

  def shoes
    subcategories(Category::SHOE).reject{ |sub| CARE_PRODUCTS.include? sub[1] }
  end

  def care_shoes
    subcategories(Category::SHOE).select { |sub| CARE_PRODUCTS.include?(sub[1]) }
  end

  def bags
    subcategories(Category::BAG)
  end

  def accessories
    subcategories(Category::ACCESSORY)
  end

  def clothes
    subcategories(Category::CLOTH)
  end

  def shoe_sizes
    in_category(Category::SHOE).group(:shoe_size).order("shoe_size asc").map { |p| p.shoe_size }.compact
  end

  def brands_for category
    in_category(category).group(:brand).order("IF(UPPER(products.brand) in ('OLOOK', 'OLOOK CONCEPT'),1,2), brand asc").map { |p| p.brand }.compact
  end

  def cloth_sizes
    in_category(Category::CLOTH).group(:cloth_size).count.keys.compact.sort { |a,b| CLOTH_SIZES_TABLE[a.to_s].to_i <=> CLOTH_SIZES_TABLE[b.to_s].to_i }
  end

  def heels
    in_category(Category::SHOE).group(:heel).order("heel asc").map { |p| [p.heel, p.heel_label] if p.heel }.compact.sort{ |a,b| a[0].to_i <=> b[0].to_i }
  end
end
