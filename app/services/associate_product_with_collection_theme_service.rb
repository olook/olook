# -*- encoding : utf-8 -*-
class AssociateProductWithCollectionThemeService
  attr_accessor :response_keys, :product_ids

  def initialize(collection_theme_id, product_ids)
    @response_keys = {not_found: [], not_inventory: [], not_visible: [], successfull: []}
    @collection_theme_id = collection_theme_id
    @product_ids = product_ids.split(/\D/).compact
  end

  def associate_collection_themes_and_products
    fill_hash_info
    associate_ids
  end

  def associate_ids

  end

  def process
    product_ids.each do |id|
      product = Product.find_by_id(id)
      case
      when product.nil?
        response_keys[:not_found] << id
      when !product.is_visible?
        response_keys[:not_visible] << product.id
      when product.inventory.zero?
        response_keys[:not_inventory] << product.id
      else
        response_keys[:successful] << product.id
      end
    end
  end
end
