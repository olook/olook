class ProductDocument
  attr_writer :type, :version, :id, :lang
  FIELDS = [
    'product_id', 'is_visible', 'brand', 'brand_facet', 'price',
    'retail_price', 'discount', 'in_promotion', 'visibility',
    'category', 'age', 'name', 'inventory', 'care', 'image',
    'backside_image', 'size', 'collection', 'collection_theme',
    'r_age', 'r_brand_regulator', 'r_inventory', 'heel', 'heeluint',
    'subcategory', 'color', 'keywords'
  ]
  FIELDS.each do |f|
    define_method "#{f}" do
      @fields[f]
    end

    define_method "#{f}=" do |val|
      @fields[f] = val
    end
  end

  def []=(key, value)
    @fields[key.to_s] = value
  end

  def [](key)
    @fields[key.to_s]
  end

  def to_document
    {
      type: @type,
      id: @id,
      fields: @fields
    }
  end

  def initialize
    @fields = {}
  end

  def is_visible= is_visible
    @fields['is_visible'] = is_visible ? 1 : 0
  end

  def brand= brand
    @fields['brand'] = brand.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
    set_brand_facet brand
  end

  def set_brand_facet brand
    @fields['brand_facet'] = ActiveSupport::Inflector.transliterate(brand).gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize
  end

  def price= price
    @fields['price'] = (price.to_d * 100).round
  end

  def retail_price= retail_price
    @fields['retail_price'] = (retail_price.to_d * 100).round  
  end

  def in_promotion= in_promotion 
    @fields['in_promotion'] = in_promotion ? 1 : 0 
  end

  def category= category
    @fields['category'] = category.downcase
  end

  def calculate_discount
    @fields['discount'] = (@fields['retail_price'].to_i * 100) / @fields['price'].to_i
  end

  def collection= collection
    @fields['collection'] = collection.strftime('%Y%m').to_i
  end

  def backside_image= backside_image
    @fields['backside_image'] = backside_image unless backside_image.nil?
  end

  def name= name
    @fields['name'] = name.titleize
  end

  def inventory= inventory
    @fields['inventory'] = inventory.to_i
  end

  def care= care
    @fields['care'] = care.titleize
  end

  def keywords
    ['category', 'subcategory', 'color', 'size', 'name', 'brand']
  end

  def keywords= keywords
    @fields['keywords'] = keywords
  end

  def method_missing(m, *args, &block)
    if /(?<filter_name>.*)=/ =~ m
      @filters[filter_name] = args
    else
      @filters[m] || super
    end
  end

end
