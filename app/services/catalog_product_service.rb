class CatalogProductService
  
  def initialize catalog, product, options = {}
    @catalog = catalog
    @product = product
    @options = options
    @options[:discount_percentage] ||= 0
    @options[:update_price] ||= false
  end

  def save!
    if shoe? and not shoe_sizes.empty?
      save_shoe_by_size
    else
      create_or_update_product
    end
  end
  
  def retail_price
    (@product.price * (100 - @options[:discount_percentage].to_f)) / 100
  end

  private
  def save_shoe_by_size
    shoe_sizes.each do |variant|
      create_or_update_product(:shoe_size => variant[:shoe_size],
                               :heel => @product.heel.try(:parameterize),
                               :heel_label => @product.heel,
                               :inventory => variant[:inventory],
                               :variant_id => variant[:id]
                               )
    end
  end
  
  def default_params
    {
      :catalog_id => @catalog.id,
      :product_id => @product.id,
      :category_id => @product.category,
      :subcategory_name => @product.subcategory_name.try(:parameterize),
      :subcategory_name_label => @product.subcategory_name,
      :original_price => @product.price,
      :retail_price => retail_price,
      :discount_percent => @options[:discount_percentage],
      :variant_id => (last_variant.id if last_variant),
      :inventory => (last_variant.inventory if last_variant)
    }
  end
  
  def existing_product options=nil
    params = {
      :catalog_id => @catalog.id,
      :product_id => @product.id
    }
    if options
      options.delete(:inventory)
      params.merge! options
    end
    Catalog::Product.where(params).first
  end

  def create_or_update_product options=nil
    params = default_params
    params.merge!(options) if options
    if existing_product(options)
       massive_update!(params)
    else
      Catalog::Product.create(params)
    end
  end
  
  def massive_update! params
    @catalog.products.where(:product_id => @product.id).update_all(:discount_percent => @options[:discount_percentage], :retail_price => retail_price)
  end

  def last_variant
    @product.variants.last
  end

  def shoe_sizes
    @product.variants.map{|v| {:shoe_size => v.description.to_i, :inventory => v.inventory, :id => v.id } } if shoe?
  end

  def shoe?
    @product.category == Category::SHOE
  end
end
