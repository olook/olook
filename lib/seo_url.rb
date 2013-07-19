# encoding: utf-8
require 'active_support/inflector'
class SeoUrl

  VALUES = HashWithIndifferentAccess.new({
    "tamanho" => "size",
    "cor" => "color",
    "preco" => "price",
    "salto" => "heel",
    "colecao" => "collection",
    "por" => "sort",
    "menor-preco" => "retail_price",
    "maior-preco" => "-retail_price",
    "maior-desconto" => "-desconto",
    "conforto" => "care",
    "colecao" => "collection",
    "por_pagina" => "per_page"
  })
  CARE_PRODUCTS = [
    'Amaciante', 'Apoio plantar', 'Impermeabilizante', 'Palmilha', 'Proteção para calcanhar',
    'amaciante', 'apoio plantar', 'impermeabilizante', 'palmilha', 'proteção para calcanhar',
    'amaciante', 'apoio-plantar', 'impermeabilizante', 'palmilha', 'protecao-para-calcanhar'
  ]

  PARAMETERS_BLACKLIST = [ "price" ]
  PARAMETERS_WHITELIST = [ "price", "sort", "per_page" ]

  def self.parse parameters, other_parameters={}
    parsed_values = HashWithIndifferentAccess.new

    parsed_values[:category] = extract_category(parameters, other_parameters)
    parsed_values[:brand] = extract_brand(parameters, other_parameters)
    parsed_values[:subcategory] = extract_subcategories(parameters, other_parameters)

    parsed_values.merge!(parse_filters(parameters))
    parsed_values.merge!(translate_other_parameters(other_parameters))

    parsed_values
  end

  def self.build_for current_key, params, other_params={  }
    return_hash = build(params, other_params)
    return_hash.delete(current_key.to_sym)
    path = [ return_hash[:category], return_hash[:brand], return_hash[:subcategory] ].flatten.select {|p| p.present? }.uniq.map{ |p| ActiveSupport::Inflector.transliterate(p).downcase }.join('-')
    { parameters: [path, return_hash[:filter_params]].reject { |p| p.blank? }.join('/') }.merge(return_hash[:order_params])
  end

  def self.all_categories
    YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_categories.yml' ) ) ) )
  end

  private

    def self.all_brands
      YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_brands.yml' ) ) ) )
    end

    def self.translate_other_parameters(other_parameters)
      parsed_values = {}
      other_parameters.each do |k, v|
        if VALUES[k]
          parsed_values[VALUES[k]] = VALUES[v].present? ? VALUES[v] : v
        end
      end
      parsed_values
    end

    def self.extract_category(parameters, other_parameters={})
      return other_parameters[:category] if other_parameters[:category]
      (parameters.to_s.split('/').first.to_s.split('-') & categories).join('-')
    end

    def self.extract_brand(parameters, other_parameters)
      return other_parameters[:brand] if other_parameters[:brand]
      brands = (all_brands & parameters.to_s.split('/').first.to_s.split('-').map { |s| ActiveSupport::Inflector.transliterate(s).titleize })
      brands.join("-") if brands.any?
    end

    def self.extract_subcategories(parameters, other_parameters)
      subcategories_and_brands = parameters.to_s.split("/").first.split("-") rescue []
      _all_subcategories = self.all_subcategories || []
      unless other_parameters[:search]
        _all_subcategories -= CARE_PRODUCTS.map { |s| ActiveSupport::Inflector.transliterate(s) }
      end
      subcategories = (subcategories_and_brands.map { |s| ActiveSupport::Inflector.transliterate(s) } & _all_subcategories)
      subcategories.join("-") if subcategories.any?
    end

    def self.categories
      cat = YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_categories.yml' ) ) ) )
      cat = cat.keys
      cat.concat( cat.map{ |s| s.downcase } )
      cat.concat( cat.map{ |s| ActiveSupport::Inflector.transliterate(s) } )
      cat.concat( cat.map{ |s| s.parameterize } )
      cat
    end

    def self.parse_filters(parameters)
      filter_params = parameters.to_s.split("/").last
      parsed_values = {}
      filter_params.to_s.split('_').each do |item|
        auxs = item.split('-')
        key = auxs.shift
        vals = auxs.join('-')
        parsed_values[VALUES[key]] = vals
      end
      parsed_values
    end

    def self.build params, other_params = {  }
      parameters = params.dup
      other_parameters = other_params.dup
      return_hash = {}
      return_hash[:brand] = ActiveSupport::Inflector.transliterate(parameters.delete(:brand).join("-")).downcase if parameters[:brand].present?
      return_hash[:subcategory] = ActiveSupport::Inflector.transliterate(parameters.delete(:subcategory).join("-").downcase) if parameters[:subcategory].present?
      return_hash[:category] = ActiveSupport::Inflector.transliterate(parameters.delete(:category).first.to_s).downcase if parameters[:category].present?

      post_parameters = {}
      other_parameters.select{|k,v| PARAMETERS_WHITELIST.include?(k.to_s) }.each do |k,v|
        if k.to_s == "sort"
          v = VALUES.invert[v]
        end
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
      subs = YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../config/seo_url_subcategories.yml' ) ) ) )
      subs.concat( subs.map{ |s| s.downcase } )
      subs.concat( subs.map{ |s| ActiveSupport::Inflector.transliterate(s) } )
      subs.concat( subs.map{ |s| s.parameterize } )
    end
end
