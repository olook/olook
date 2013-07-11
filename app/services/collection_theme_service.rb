# -*- encoding : utf-8 -*-
class CollectionThemeService
  attr_accessor :response_keys

  def initialize(collection_theme_id, product_ids)
    @response_keys = {not_found: [], not_inventory: [], not_visible: [], successfull: []}
    @collection_theme_id = collection_theme_id
    @product_ids = product_ids
  end

  def associate_collection_themes_and_products
    response_keys
  end

  def associate_ids

  end
end
