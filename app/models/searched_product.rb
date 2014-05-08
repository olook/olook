class SearchedProduct
  include Search::Searchable
  field :name, :literal
  field :model_name, :literal
  field :category, :literal
  field :image, :literal
  field :backside_image, :literal
  field :price, :decimal, scale: 2
  field :brand, :literal
  field :retail_price, :decimal, scale: 2
  field :inventory, :uint

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
