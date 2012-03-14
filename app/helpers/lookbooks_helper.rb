module LookbooksHelper
  def get_partial(product)
    if product.liquidation?
      render "shared/promotion_product_item", :liquidation_product => LiquidationProductService.liquidation_product(product)
    else
      render "shared/showroom_product_item", :product => product
    end
  end
end
