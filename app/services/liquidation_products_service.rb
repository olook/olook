class LiquidationProductsService

  def initialize liquidation_id
    @liquidation = Liquidation.find(liquidation_id)
  end

  def add products_ids, discount_percent
    products_ids.split(",").each do |product_id|
      product = Product.find product_id
      LiquidationProductService.new(product, discount_percent)
    end
  end

  class LiquidationProductService
    def initialize product
      @product = product
    end

    def retail_price
      #@product.price
    end

    def subcategory_name
      detail_by_token "Categoria"
    end

    def heel
      detail_by_token "Salto/Tamanho"
    end

    def detail_by_token token
      detail = @product.details.where(:translation_token => token).last
      detail.description if detail
    end

    def shoe_sizes
      @product.variants.map(&:description) if @product.category == 1
    end

    def save
      shoe_sizes.each do |shoe_size|
        LiquidationProduct.create(
          :product_id => product_id,
          :category_id => @product.category,
          :subcategory_name => subcategory_name,
          :original_price => product.price,
          :retail_price => retail_price,
          :discount_percent => discount_percent,
          :shoe_size => shoe_size,
          :heel => heel
        )
      end
    end
  end

end
