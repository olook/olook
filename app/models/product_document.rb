class ProductDocument
  attr_writer :type, :version, :id, :lang
  FIELDS = [
    :product_id, :is_visible, :brand, :brand_facet, :price,
    :retail_price, :discount, :in_promotion, :visibility,
    :category, :age, :name, :inventory, :care, :image,
    :backside_image, :size, :collection, :collection_theme,
    :r_age, :r_brand_regulator, :r_inventory, :heel, :heeluint,
    :subcategory, :color, :keywords
  ]
  FIELDS.each do |f|
    define_method "#{f}" do
      @fields[f]
    end

    define_method "#{f}=" do |val|
      @fields[f] = val
    end
  end

  def to_document
    {
      type: @type,
      version: @version,
      lang: @lang,
      id: @id,
      fields: @fields
    }
  end

  def keywords
    ['category', 'subcategory', 'color', 'size', 'name', 'brand', 'material externo', 'material interno', 'material da sola']
  end

  def method_missing(m, *args, &block)
    if /(?<filter_name>.*)=/ =~ m
      @filters[filter_name] = args
    else
      @filters[m] || super
    end
  end
end
