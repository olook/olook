class SearchedProduct
  include Search::Searchable
  add_field :name, :literal
  add_field :model_name, :literal
  add_field :product_id, :literal
  add_field :category, :literal
  add_field :subcategory, :literal
  add_field :care, :literal
  add_field :collection_theme, :literal
  add_field :image, :literal
  add_field :backside_image, :literal
  add_field :price, :decimal, scale: 2
  add_field :brand, :literal
  add_field :retail_price, :decimal, scale: 2
  add_field :inventory, :uint
  add_field :is_visible, :boolean
  add_field :in_promotion, :boolean
  add_field :visibility, :text, array: true
  add_field :heeluint, :uint
  add_field :size, :literal, array: true

  alias :formatted_name :name
  alias :catalog_image :image
  alias :catalog_picture :image
  alias :backside_picture :backside_image

  def seo_path
    "#{self.formatted_name.to_s.parameterize}-#{self.id.to_s}"
  end

  def promotion?
    retail_price.to_d < price.to_d
  end

  def item_view_cache_key_for shoe_size
    "_product_item:#{id}"
  end

  def sold_out?
    false
  end

  def discount_percent
    ((price.to_d - retail_price.to_d) / price.to_d * 100.0.to_d).to_d
  end
end
