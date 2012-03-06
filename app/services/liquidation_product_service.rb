class LiquidationProductService
  def initialize liquidation, product, discount_percent
    @liquidation = liquidation
    @product = product
    @discount_percent = discount_percent
  end

  def retail_price
    (@product.price * @discount_percent.to_f) / 100
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
    @product.variants.map(&:description) if shoe?
  end

  def shoe?
    @product.category == 1
  end

  def save
    if shoe? and not shoe_sizes.empty?
      save_shoe_by_size
    else
      create_or_update_product
    end
  end
  
  def save_shoe_by_size
    shoe_sizes.each do |shoe_size|
      create_or_update_product(:shoe_size => shoe_size, :heel => heel)
    end
  end
  
  def create_or_update_product options=nil
    params = default_params.merge!(options)
    if existing_product
      existing_product.update_attributes!(params)
    else
      LiquidationProduct.create(params)
    end
  end
  
  def default_params
    {
      :liquidation_id => @liquidation.id,
      :product_id => @product.id,
      :category_id => @product.category,
      :subcategory_name => subcategory_name,
      :original_price => @product.price,
      :retail_price => retail_price,
      :discount_percent => @discount_percent
    }
  end
  
  #TODO: find all by shoe size
  def existing_product
    LiquidationProduct.where(
     :liquidation_id => @liquidation.id,
     :product_id => @product.id
    ).first
  end
end
