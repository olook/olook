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
    "maior-desconto" => "-desconto",
    "conforto" => "care",
    "colecao" => "collection"
  }

  PARAMETERS_BLACKLIST = [ "price" ]
  PARAMETERS_WHITELIST = [ "price", "sort_price" ]

  def self.parse parameters, other_parameters={}
    parsed_values = HashWithIndifferentAccess.new

    _all_brands = self.all_brands || []
    _all_subcategories = self.all_subcategories || []

    unless other_parameters[:search]
      _all_subcategories -= Product::CARE_PRODUCTS.map { |s| ActiveSupport::Inflector.transliterate(s) }
      self.all_categories
    end

    all_parameters = parameters.to_s.split("/")
    parsed_values[:category] = all_parameters.shift

    subcategories_and_brands = all_parameters.first.split("-") rescue []

    subcategories = (_all_subcategories & subcategories_and_brands.map { |s| ActiveSupport::Inflector.transliterate(s).titleize })
    brands = (_all_brands & subcategories_and_brands.map { |s| ActiveSupport::Inflector.transliterate(s).titleize })

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

    parsed_values[:sort] = VALUES[other_parameters["por"]]

    parsed_values
  end

  def self.parse_brands parameters, other_parameters={}
    parsed_values = HashWithIndifferentAccess.new
    _all_subcategories = self.all_subcategories || []

    all_parameters = parameters.to_s.split("/")
    parsed_values[:brand] = all_parameters.shift
    parsed_values[:category] = all_parameters.shift if all_parameters.any? && all_categories.keys.map(&:parameterize).include?(ActiveSupport::Inflector.transliterate(all_parameters.first))
    parsed_values[:subcategory] = all_parameters.shift if all_parameters.any? && (_all_subcategories & all_parameters.first.split("-").map { |s| ActiveSupport::Inflector.transliterate(s).titleize }).any?

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

    parsed_values[:sort] = VALUES[other_parameters["por"]]

    parsed_values
  end

  def self.build_for_catalogs params, other_params={  }
    return_hash = build(params, other_params)
    path = [ return_hash[:brand], return_hash[:subcategory] ].flatten.select {|p| p.present? }.uniq.map{ |p| ActiveSupport::Inflector.transliterate(p).downcase }.join('-')
    { parameters: [return_hash[:category], path, return_hash[:filter_params]].reject { |p| p.blank? }.join('/') }.merge(return_hash[:order_params])
  end

  def self.build_for_brands params, other_params={  }
    return_hash = build(params, other_params)
    { parameters: [
      params[:brand].empty? ? other_params[:brand] : params[:brand].last,
      return_hash[:category],
      return_hash[:subcategory],
      return_hash[:filter_params]
      ].reject { |p| p.blank? }.join('/')
    }.merge(return_hash[:order_params])
  end

  def self.all_categories
    YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_categories.yml' ) ) ) )
  end

  def self.all_brands
    YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_brands.yml' ) ) ) )
  end

  private
    def self.build params, other_params = {  }
      parameters = params.dup
      other_parameters = other_params.dup
      return_hash = {}
      return_hash[:brand] = ActiveSupport::Inflector.transliterate(parameters.delete(:brand).join("-")).downcase if parameters[:brand].present?
      return_hash[:subcategory] = ActiveSupport::Inflector.transliterate(parameters.delete(:subcategory).join("-").downcase) if parameters[:subcategory].present?
      return_hash[:category] = ActiveSupport::Inflector.transliterate(parameters.delete(:category).first.to_s).downcase if parameters[:category].present?

      post_parameters = {}

      other_parameters.select{|k,v| PARAMETERS_WHITELIST.include?(k) }.each do |k,v|
        post_parameters[VALUES.invert[k.to_s]] = v.respond_to?(:join) ? v.join('-') : v
      end

      filter_params = []
      parameters.each do |k, v|
        if v.respond_to?(:join)
          filter_params << "#{VALUES.invert[k.to_s]}-#{v.map{|_v| ActiveSupport::Inflector.transliterate(_v).downcase}.join('-')}" if v.present? && PARAMETERS_BLACKLIST.exclude?(k.to_s)
        end
      end

      return_hash[:filter_params] = filter_params.join('_')
      return_hash[:order_params] = post_parameters

      return_hash
    end

    def self.all_subcategories
      YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_subcategories.yml' ) ) ) )
    end
end
