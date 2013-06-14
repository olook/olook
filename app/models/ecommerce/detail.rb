# -*- encoding : utf-8 -*-
class Detail < ActiveRecord::Base
  belongs_to :product

  validates :product, :presence => true
  validates :translation_token, :presence => true
  validates :description, :presence => true

  has_enumeration_for :display_on, :with => DisplayDetailOn, :required => true

  scope :only_invisible     , where(:display_on => DisplayDetailOn::INVISIBLE)
  scope :only_specification , where(:display_on => DisplayDetailOn::SPECIFICATION).where("translation_token not like 'Cor%'")
  scope :with_valid_values  , where("description <> '_'")
  scope :only_how_to        , where(:display_on => DisplayDetailOn::HOW_TO)

  def self.colors(product_category)
    product_category = product_category.blank? ? Category.list.join(',') : product_category
    Rails.cache.fetch(CACHE_KEYS[:detail_color][:key] % product_category, expires_in: CACHE_KEYS[:detail_color][:expire]) do
      joins(:product).where("details.translation_token = 'Cor filtro'").
        where('products.is_visible = true').
        where("products.category IN (#{product_category})").
        map{|a| a.description.parameterize}.compact.uniq
    end
  end

  def self.subcategories(product_category)
    joins(:product).where("details.translation_token = 'Categoria'").
    where('products.is_visible = true').
    where("products.category = #{product_category}").
    map{|a| a.description.parameterize}.compact.uniq
  end
end
