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
    "novidade" => "age",
    "conforto" => "care",
    "colecao" => "collection",
    "por_pagina" => "per_page"
  })
  CARE_PRODUCTS = [
    'Amaciante', 'Apoio plantar', 'Impermeabilizante', 'Palmilha', 'Proteção para calcanhar',
    'amaciante', 'apoio plantar', 'impermeabilizante', 'palmilha', 'proteção para calcanhar',
    'amaciante', 'apoio-plantar', 'impermeabilizante', 'palmilha', 'protecao-para-calcanhar'
  ]

  FIELD_SEPARATOR = '_'
  PARAMETERS_BLACKLIST = [ "price" ]
  PARAMETERS_WHITELIST = [ "price", "sort", "per_page" ]

  def initialize(path, current_key=nil, search=nil)
    if path.is_a?(Hash)
      @params = path
    else
      @path = path
      @params = HashWithIndifferentAccess.new
    end
    @search = search
    @current_key = current_key
  end

  def parse_params
    if from_brands?
      parse_brands_params
    elsif from_collections?
      parse_collections_params
    elsif from_olooklet?
      parse_olooklet_params
    else
      parse_catalogs_params
    end
    parse_query

    parsed_values = HashWithIndifferentAccess.new
    parsed_values[:collection_theme] = @params[:collection_theme]
    parsed_values[:brand] = @params[:brand] || extract_brand
    parsed_values[:excluded_brand] = @params[:excluded_brand] if @params[:excluded_brand]
    parsed_values[:category] = @params[:category] || ((@params[:parameters].to_s.split('/').first.to_s.split(SearchEngine::MULTISELECTION_SEPARATOR) & categories).join(SearchEngine::MULTISELECTION_SEPARATOR))
    parsed_values[:subcategory] = extract_subcategories
    parsed_values.merge!(parse_filters)
    parsed_values.merge!(parse_order)
    parsed_values
  end

  def self.parse parameters
    self.new(parameters).parse_params
  end

  def current_filters
    parameters = HashWithIndifferentAccess.new(@search.current_filters.dup)
    build_link_for parameters
  end

  def remove_filter_of(filter)
    parameters = HashWithIndifferentAccess.new(@search.remove_filter(filter.to_sym).dup)
    build_link_for parameters
  end

  def add_filter(filter, filter_text)
    parameters = HashWithIndifferentAccess.new(@search.filters_applied(filter.to_sym, filter_text.chomp).dup)
    build_link_for parameters
  end

  def self.all_categories
    YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_categories.yml' ) ) ) )
  end

  private

    def parse_query
      if @query.present?
        @query.split('&').each do |var|
          k, v = var.split('=').map { |i| URI.decode(i.to_s) }
          @params[k] = v
        end
      end
    end

    def from_brands?
       /^\/marcas\// =~ @path
    end

    def from_collections?
      /^\/colecoes\// =~ @path
    end

    def from_olooklet?
      /^\/olooklet(\/)*/ =~ @path
    end

    def parse_brands_params
      /^\/marcas\/(?<brand>[^\/\?]*)(?:\/(?<parameters>[^\?]+))?(?:\?(?<query>.*))?/ =~ @path
      @params[:brand] = URI.decode(brand.to_s)
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_collections_params
      /^\/colecoes\/(?<collection_theme>[^\/\?]*)(?:\/(?<parameters>[^\?]+))?(?:\?(?<query>.*))?/ =~ @path
      @params[:collection_theme] = URI.decode(collection_theme.to_s)
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_catalogs_params
      /^(?:\/catalogo)?\/(?<category>[^\/\?]*)(?:\/(?<parameters>[^\?]+))?(?:\?(?<query>.*))?/ =~ @path
      @params[:category] = URI.decode(category.to_s)
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_olooklet_params
      /^(?:\/olooklet)(?:\/(?<category>[^\/\?]*)(?:\/(?<parameters>[^\?]+))?(?:\?(?<query>.*))?)?/ =~ @path
      @params[:category] = URI.decode(category.to_s)
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end


    def build_link_for parameters
      other_parameters = @params.dup
      return_hash = {}
      return_hash[:brand] = ActiveSupport::Inflector.transliterate(parameters.delete(:brand).join(SearchEngine::MULTISELECTION_SEPARATOR)).downcase if parameters[:brand].present?
      return_hash[:subcategory] = ActiveSupport::Inflector.transliterate(parameters.delete(:subcategory).join(SearchEngine::MULTISELECTION_SEPARATOR).downcase) if parameters[:subcategory].present?
      return_hash[:category] = ActiveSupport::Inflector.transliterate(parameters.delete(:category).first.to_s).downcase if parameters[:category].present?

      post_parameters = {}
      other_parameters.select{|k,v| PARAMETERS_WHITELIST.include?(k.to_s) }.each do |k,v|
        if k.to_s == "sort"
          v = VALUES.invert[v]
        end
        post_parameters[VALUES.invert[k.to_s]] = v.respond_to?(:join) ? v.join(SearchEngine::MULTISELECTION_SEPARATOR) : v
      end

      filter_params = []
      parameters.each do |k, v|
        if v.respond_to?(:join)
          filter_params << "#{VALUES.invert[k.to_s]}-#{v.map{|_v| ActiveSupport::Inflector.transliterate(_v).downcase}.join(SearchEngine::MULTISELECTION_SEPARATOR)}" if v.present? && PARAMETERS_BLACKLIST.exclude?(k.to_s) && VALUES.invert[k.to_s]
        end
      end

      return_hash[:filter_params] = filter_params.join(FIELD_SEPARATOR)
      return_hash[:order_params] = post_parameters

      return_hash.delete(@current_key.to_sym) if @current_key
      path = [ return_hash[:category], return_hash[:brand], return_hash[:subcategory] ].flatten.select {|p| p.present? }.uniq.map{ |p| ActiveSupport::Inflector.transliterate(p).downcase }.join(SearchEngine::MULTISELECTION_SEPARATOR)
      { parameters: [path, return_hash[:filter_params]].reject { |p| p.blank? }.join('/') }.merge(return_hash[:order_params])
    end

    def all_brands
      YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_brands.yml' ) ) ) )
    end

    def parse_order
      parsed_values = {}
      @params.each do |k, v|
        if VALUES[k]
          parsed_values[VALUES[k]] = VALUES[v].present? ? VALUES[v] : v
        end
      end
      parsed_values
    end

    def extract_brand
      brands = (all_brands & @params[:parameters].to_s.split('/').first.to_s.split(SearchEngine::MULTISELECTION_SEPARATOR).map { |s| ActiveSupport::Inflector.transliterate(s).titleize })
      brands.join(SearchEngine::MULTISELECTION_SEPARATOR) if brands.any?
    end

    def extract_subcategories
      subcategories_and_brands = @params[:parameters].to_s.split("/").first.split(SearchEngine::MULTISELECTION_SEPARATOR) rescue []
      _all_subcategories = all_subcategories || []
      unless @params[:search]
        _all_subcategories -= CARE_PRODUCTS.map { |s| ActiveSupport::Inflector.transliterate(s) }
      end
      subcategories = (subcategories_and_brands.map { |s| ActiveSupport::Inflector.transliterate(s) } & _all_subcategories)
      subcategories.join(SearchEngine::MULTISELECTION_SEPARATOR) if subcategories.any?
    end

    def categories
      cat = YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_categories.yml' ) ) ) )
      cat = cat.keys
      cat.concat( cat.map{ |s| s.downcase } )
      cat.concat( cat.map{ |s| ActiveSupport::Inflector.transliterate(s) } )
      cat.concat( cat.map{ |s| s.parameterize } )
      cat
    end

    def parse_filters
      filter_params = @params[:parameters].to_s.split("/").last
      parsed_values = {}
      filter_params.to_s.split(FIELD_SEPARATOR).each do |item|
        auxs = item.split(SearchEngine::MULTISELECTION_SEPARATOR)
        key = auxs.shift
        vals = auxs.join(SearchEngine::MULTISELECTION_SEPARATOR)
        parsed_values[VALUES[key]] = vals
      end
      parsed_values
    end

    def all_subcategories
      subs = YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_subcategories.yml' ) ) ) )
      subs.concat( subs.map{ |s| s.downcase } )
      subs.concat( subs.map{ |s| ActiveSupport::Inflector.transliterate(s) } )
      subs.concat( subs.map{ |s| s.parameterize } )
    end
end
