class SearchedProduct

  attr_accessor :id, :formatted_name, :model_name, :category, :catalog_image, :backside_picture, :price, :brand
  attr_writer :promotion

  def initialize id, data
    self.id = id
    self.formatted_name = data["name"][0]
    self.model_name = data["categoria"][0]
    self.category = data["category"][0]
    self.catalog_image = data["image"][0]
    self.backside_picture = data["backside_image"][0]
    self.brand = data["brand"][0]
    self.price = BigDecimal.new(data["price"][0])
    self.promotion = false
  end

  def promotion?
    @promotion
  end

end
