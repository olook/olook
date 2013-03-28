module LookbooksHelper
  def get_partial(product)
    if product.liquidation?
      render "shared/product_item", :product => LiquidationProductService.liquidation_product(product)
    else
      render "shared/product_item", :product => product
    end
  end
end
