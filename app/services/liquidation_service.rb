class LiquidationService
  def initialize liquidation_id
    @liquidation = Liquidation.find(liquidation_id)
  end

  def add products_ids, discount_percent
    products_ids.split(",").each do |product_id|
      product = Product.find product_id
      LiquidationProductService.new(@liquidation, product, discount_percent).save
    end
  end
end