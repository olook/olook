class CatalogProductService

  def initialize catalog, product, options = {}
    @catalog = catalog
    @product = product
    @options = options
    @options[:discount_percentage] ||= 0
    @options[:update_price] ||= false
  end

  def save!
    if @product.shoe?
      create_or_update_shoes
    else
      create_or_update
    end
  end

  def retail_price
    (@product.price * (100 - @options[:discount_percentage].to_f)) / 100
  end

  def destroy
    @catalog.products.where(:product_id => @product.id).delete_all
  end

  private
  def default_params
    last_variant = @product.variants.last

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

  def existing_product? options
    @catalog.products.where(
      :product_id => @product.id,
      :variant_id => options[:variant_id]
    ).first
  end

  def create_or_update options=nil
    params = default_params
    params.merge!(options) if options
    if (product = existing_product?(params))
      unless @options[:update_price]
        params.delete(:original_price)
        params.delete(:retail_price)
        params.delete(:discount_percent)
      end

      product.update_attributes!(params)
      product.reload
    else
      @catalog.products.create!(params)
    end
  end

  def shoe_sizes
    @product.variants.map{|v| {:shoe_size => v.description.to_i, :inventory => v.inventory, :id => v.id } }
  end

  def create_or_update_shoes
    shoe_sizes.inject([]) do |products, variant|
      products << create_or_update(
        :shoe_size => variant[:shoe_size],
        :shoe_size_label => variant[:shoe_size].to_s,
        :heel => @product.heel.try(:parameterize),
        :heel_label => @product.heel,
        :inventory => variant[:inventory],
        :variant_id => variant[:id]
      )
    end
  end
end
