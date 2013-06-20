class SeoUrl

  VALUES = {
    "tamanho" => "size",
    "cor" => "color"
  }

  def self.parse parameters
    parsed_values = HashWithIndifferentAccess.new

    _all_brands = self.all_brands || []
    _all_subcategories = self.all_subcategories || []

    all_parameters = parameters.split("/")
    subcategories_and_brands = all_parameters.first.split("-")
    subcategories = []
    brands = []

    if all_parameters.size > 1
      filter_params = all_parameters.last
    else
      filter_params = parameters
    end

    subcategories_and_brands.each do |sub|
      if _all_subcategories.include?(sub)
        subcategories << sub
      end
    end

    subcategories_and_brands.each do |sub|
      if _all_brands.include?(sub)
        brands << sub
      end
    end

    parsed_values.merge!(subcategory: subcategories.join("-")) if subcategories.any?
    parsed_values.merge!(brand: brands.join("-")) if brands.any?
    filter_params.split('_').each do |item|
      auxs = item.split('-')
      key = auxs.shift
      vals = auxs.join('-')
      parsed_values[VALUES[key]] = vals
    end

    parsed_values
  end

  private
    def self.all_subcategories
      Rails.cache.fetch CACHE_KEYS[:all_subcategories][:key]
    end

    def self.all_brands
      Rails.cache.fetch CACHE_KEYS[:all_brands][:key]
    end
end
