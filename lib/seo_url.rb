class SeoUrl

  VALUES = {
    "tamanho" => "size",
    "cor" => "color",
    "preco" => "price",
    "salto" => "heel",
    "colecao" => "collection"
  }

  def self.parse parameters
    parsed_values = HashWithIndifferentAccess.new

    _all_brands = self.all_brands || []
    _all_subcategories = self.all_subcategories || []

    all_parameters = parameters.split("/")
    parsed_values[:category] = all_parameters.shift

    subcategories_and_brands = all_parameters.first.split("-") rescue []
    subcategories = []
    brands = []

    subcategories_and_brands.each do |sub|
      if _all_subcategories.include?(sub.camelize)
        subcategories << sub
      end
    end

    subcategories_and_brands.each do |sub|
      if _all_brands.include?(sub.camelize)
        brands << sub
      end
    end
    parsed_values[:subcategory] = subcategories.join("-") if subcategories.any?
    parsed_values[:brand] = brands.join("-") if brands.any?

    if all_parameters.size > 1
      filter_params = all_parameters.last
    else
      filter_params = parameters
    end

    filter_params.split('_').each do |item|
      auxs = item.split('-')
      key = auxs.shift
      vals = auxs.join('-')
      parsed_values[VALUES[key]] = vals
    end

    parsed_values
  end

  def self.build params
    parameters = params.dup
    category = parameters.delete(:category).first
    subcategory = parameters.delete(:subcategory)
    brand = parameters.delete(:brand)

    path = [ subcategory, brand ].select {|p| p.present? }.uniq.join('-')
    filter_params = []
    parameters.each do |k, v|
      if v.respond_to?(:join)
        filter_params << "#{VALUES.invert[k.to_s]}-#{v.join('-')}" if v.present?
      else
        filter_params << "#{VALUES.invert[k.to_s]}-#{v}" if v.present?
      end
    end
    filter_params = filter_params.join('_')
    { parameters: [category, path, filter_params].reject { |p| p.blank? }.join('/') }
  end

  private
    def self.all_subcategories
      Rails.cache.fetch CACHE_KEYS[:all_subcategories][:key] do
        Set.new(Product.includes(:details).all.map(&:subcategory).compact.map(&:titleize).uniq)
      end
    end

    def self.all_brands
      Rails.cache.fetch CACHE_KEYS[:all_brands][:key] do
        Set.new(Product.all.map(&:brand).map(&:titleize).uniq)
      end
    end
end
