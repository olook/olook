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

  def promotion?
    retail_price < price
  end

  def item_view_cache_key_for shoe_size
    "_product_item:#{id}"
  end

  def sold_out?
    product.sold_out?
  end

  def shoe?
    product.shoe?
  end

  def name
    product.name?
  end

  def catalog_picture
    catalog_image
  end

  def showroom_picture
    product.showroom_picture
  end

  def wearing_picture
    product.wearing_picture
  end

  def color_name
    product.color_name
  end

  def colors
    product.colors
  end

  def color_sample
    product.color_sample
  end

  def discount_percent
    product.discount_percent
  end

  # gambiarra temporaria
  def product
    Product.find id
  end

  def self.model_name

  end

end
