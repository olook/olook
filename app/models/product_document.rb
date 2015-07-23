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

  def to_document(type)
    if Search::Config[:api_version] == "2013-01-01"
      data = {
        type: @type,
        id: @id,
      }
      data[:fields]=@fields if type=='add'
    else
      {
        version: Time.zone.now.to_i / 60,
        lang: 'pt',
        type: @type,
        id: @id,
      }
      data[:fields]=@fields if type=='add'
    end
    data
  end

  def initialize
    @fields = {}
  end

  def color=(val)
    @fields['color'] = val.parameterize
  end

  def is_visible= is_visible
    @fields['is_visible'] = is_visible ? 1 : 0
  end

  def subcategory=(value)
    @fields['subcategory'] = value.parameterize
  end

  def brand= brand
    @fields['brand'] = brand.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.parameterize
    self.brand_facet = brand
  end

  def brand_facet=(brand)
    @fields['brand_facet'] = brand.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.parameterize
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
    @fields['category'] = category.parameterize
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
    @fields['care'] = care.parameterize(' ')
  end

  def keywords
    ['category', 'subcategory', 'color', 'size', 'name', 'brand', @fields['keywords']].flatten.join(' ')
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
