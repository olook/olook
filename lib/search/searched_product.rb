class SearchedProduct

  attr_accessor :id, :formatted_name, :model_name, :category, :catalog_image, :backside_picture, :price, :brand, :retail_price
  attr_writer :promotion

  def initialize id, data
    self.id = id
    self.formatted_name = data["name"][0]
    self.catalog_image = data["image"][0]
    self.backside_picture = data["backside_image"][0]
    self.brand = data["brand"][0]
    self.price = BigDecimal.new(data["price"][0].to_d/100.0.to_d)
    self.retail_price = BigDecimal.new(data["retail_price"][0].to_d/100.0.to_d)
    self.promotion = false
  end

  def seo_path
    self.formatted_name.to_s.parameterize + "-" + self.id.to_s
  end

  def promotion?
    retail_price < price
  end

  def item_view_cache_key_for shoe_size
    "_product_item:#{id}"
  end

  def sold_out?
    false
  end

  def catalog_picture
    catalog_image
  end

  def discount_percent
    ((price - retail_price) / price * 100.0.to_d).to_d
  end

end
