class LiquidationProductService
  def self.retail_price product
    price = product.price
    if product.liquidation?
      liquidation_product = LiquidationService.active.liquidation_products.where(:product_id => product.id).first
      price = liquidation_product.retail_price if liquidation_product
    end
    price
  end

  def self.discount_percent product
    if product.liquidation?
      liquidation_product = LiquidationService.active.liquidation_products.where(:product_id => product.id).first
      liquidation_product.discount_percent.to_i if liquidation_product
    end
  end

  def self.liquidation_product product
    LiquidationService.active.liquidation_products.where(:product_id => product.id).first
  end

  def initialize liquidation, product, discount_percent=nil, collections=[]
    @liquidation = liquidation
    @product = product
    @discount_percent = discount_percent
    @collections = collections
  end

  def liquidation_name
    @liquidation.name if included?
  end

  def included?
    @liquidation.resume[:products_ids].include? @product.id if @liquidation
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
    @product.variants.map{|v| {:shoe_size => v.description.to_i, :inventory => v.inventory, :id => v.id } } if shoe?
  end

  def shoe?
    #TODO: change this to call the category constant
    @product.category == 1
  end

  def save
    return false if conflicts_collections?
    if shoe? and not shoe_sizes.empty?
      save_shoe_by_size
    else
      create_or_update_product
    end
  end
  

  def save_shoe_by_size
    shoe_sizes.each do |variant|
      create_or_update_product(:shoe_size => variant[:shoe_size],
                               :heel => heel.try(:parameterize),
                               :heel_label => heel,
                               :inventory => variant[:inventory],
                               :variant_id => variant[:id]
                               )
    end
  end

  def create_or_update_product options=nil
    params = default_params
    params.merge!(options) if options
    if existing_product(options)
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
      :subcategory_name => subcategory_name.try(:parameterize),
      :subcategory_name_label => subcategory_name,
      :original_price => @product.price,
      :retail_price => retail_price,
      :discount_percent => @discount_percent,
      :variant_id => @product.master_variant.id,
      :inventory => @product.master_variant.inventory
    }
  end

  def existing_product options=nil
    params = {
      :liquidation_id => @liquidation.id,
      :product_id => @product.id
    }
    params.merge! options if options
    LiquidationProduct.where(params).first
  end

  def conflicts_collections?
    #@collections.map{|c| c.id }.include? @product.collection_id
    #TODO: add to an array of conflieted with collections
    false
  end
end
