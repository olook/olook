require 'active_support/inflector'
class SeoUrl

  VALUES = {
    "tamanho" => "size",
    "cor" => "color",
    "preco" => "price",
    "salto" => "heel",
    "colecao" => "collection",
    "por" => "sort_price",
    "menor-preco" => "retail_price",
    "maior-preco" => "-retail_price",
    "conforto" => "care",
    "colecao" => "collection"
  }

  def self.parse parameters, other_parameters={}
    parsed_values = HashWithIndifferentAccess.new

    _all_brands = self.all_brands || []
    _all_subcategories = self.all_subcategories || []

    unless other_parameters[:search]
      _all_subcategories -= Product::CARE_PRODUCTS.map(&:parameterize)
      self.all_categories
    end

    all_parameters = parameters.to_s.split("/")
    parsed_values[:category] = all_parameters.shift

    subcategories_and_brands = all_parameters.first.split("-") rescue []

    subcategories = (_all_subcategories & subcategories_and_brands.map(&:parameterize))
    brands = (_all_brands & subcategories_and_brands.map(&:parameterize))

    parsed_values[:subcategory] = subcategories.join("-") if subcategories.any?
    parsed_values[:brand] = brands.join("-") if brands.any?

    filter_params = all_parameters.last || []

    filter_params.split('_').each do |item|
      auxs = item.split('-')
      key = auxs.shift
      vals = auxs.join('-')
      parsed_values[VALUES[key]] = vals
    end

    other_parameters.each do |k, v|
      if VALUES[k]
        parsed_values[VALUES[k]] = v
      end
    end

    parsed_values[:sort_price] = VALUES[other_parameters["por"]]

    parsed_values
  end

  def self.build params, other_params={  }
    parameters = params.dup
    other_parameters = other_params.dup
    category = ActiveSupport::Inflector.transliterate(parameters.delete(:category).first.to_s).downcase
    subcategory = parameters.delete(:subcategory)
    order_params = other_parameters[:por].present? ? { por: other_parameters.delete(:por) } : {}
    brand = parameters.delete(:brand)

    path = [ subcategory, brand ].flatten.select {|p| p.present? }.uniq.map{ |p| ActiveSupport::Inflector.transliterate(p).downcase }.join('-')
    filter_params = []
    parameters.each do |k, v|
      if v.respond_to?(:join)
        filter_params << "#{VALUES.invert[k.to_s]}-#{v.map{|_v| ActiveSupport::Inflector.transliterate(_v).downcase}.join('-')}" if v.present?
      end
    end
    filter_params = filter_params.join('_')
    { parameters: [category, path, filter_params].reject { |p| p.blank? }.join('/') }.merge(order_params)
  end

  def self.all_categories
    Rails.cache.fetch CACHE_KEYS[:all_categories][:key], expire_in: CACHE_KEYS[:all_categories][:expire] do
      db_categories
    end
  end

  private
    def self.all_subcategories
      Rails.cache.fetch CACHE_KEYS[:all_subcategories][:key], expire_in: CACHE_KEYS[:all_subcategories][:expire] do
        db_subcategories.map{ |s| [s.parameterize, ActiveSupport::Inflector.transliterate(s.parameterize)] }.flatten.uniq
      end
    end

    def self.db_subcategories
      Product.includes(:details).all.map(&:subcategory).compact
    end

    def self.all_brands
      Rails.cache.fetch CACHE_KEYS[:all_brands][:key], expire_in: CACHE_KEYS[:all_brands][:expire] do
        db_brands.map{ |b| [b.parameterize, ActiveSupport::Inflector.transliterate(b.parameterize)] }.flatten.uniq
      end
    end

    def self.db_brands
      Product.all.map(&:brand).compact
    end


    def self.db_categories
      Product.includes(:details).all.inject({}){|k,v| k[v.category_humanize] ||= []; k[v.category_humanize].push(v.subcategory).uniq!; k[v.category_humanize].compact!; k }
    end
end
