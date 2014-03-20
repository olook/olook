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
  PARAMETERS_BLACKLIST = [ "price"]
  PARAMETERS_WHITELIST = [ "price", "sort", "per_page" ]
  MULTISELECTION_SEPARATOR = SearchEngine::MULTISELECTION_SEPARATOR
  DEFAULT_POSITIONS = '/:category:-:brand:-:subcategory:/:color:-:size:-:heel:'

  # Interface to initialize product
  # path as "/sapato/cor_preto"
  # path_positions in path as "/:category:-:brand:-:subcategory:/:color:-:size:-:heel:"
  # search as an object of SearchEngine
  # blk as a link builder to perform some prefixing such as brand_path
  # otherwise just return the path as formatted in positions.
  #
  # Other fields that are not in positions are automatically put in query string
  def initialize(optionals={}, &link_builder)
    @search = optionals[:search]

    if link_builder.respond_to?(:call)
      @link_builder = link_builder
    else
      @link_builder = lambda { |a| a }
    end

    @params = HashWithIndifferentAccess.new
    @path = optionals[:path] || ''
    @path_positions = optionals[:path_positions] || DEFAULT_POSITIONS
  end

  def set_link_builder(&blk)
    @link_builder = blk
  end

  def parse_params
    parse_path_positions
    if from_brands?
      parse_brands_params
    elsif from_collections?
      parse_collections_params
    elsif from_olooklet?
      parse_olooklet_params
    elsif from_selections?
      parse_selections_params
    elsif from_newest?
      parse_newest_params
    else
      parse_catalogs_params
    end
    parse_query

    parsed_values = HashWithIndifferentAccess.new
    parsed_values[:collection_theme] = @params[:collection_theme]

    parsed_values[:brand] = extract_brand
    parsed_values[:excluded_brand] = @params[:excluded_brand] if @params[:excluded_brand]

    matched_categories = categories.uniq.select {|category| @params[:parameters] =~ /#{category}/}
    parsed_values[:category] = @params[:category] || matched_categories.join(MULTISELECTION_SEPARATOR)
    parsed_values[:subcategory] = extract_subcategories
    parsed_values[:visibility] = @params[:visibility]

    parsed_values.merge!(parse_filters)
    parsed_values.merge!(parse_order)
    parsed_values
  end

  def self.parse parameters
    self.new(parameters).parse_params
  end

  def current_filters(&blk)
    parameters = HashWithIndifferentAccess.new(@search.current_filters.dup)
    parameters = build_link_for(parameters)
    parameters = blk.call(parameters) if blk
    @link_builder.call(parameters)
  end

  def remove_filter_of(filter, &blk)
    parameters = HashWithIndifferentAccess.new(@search.remove_filter(filter.to_sym).dup)
    parameters = build_link_for(parameters)
    parameters = blk.call(parameters) if blk
    @link_builder.call(parameters)
  end

  def replace_filter(filter, filter_text, &blk)
    parameters = HashWithIndifferentAccess.new(@search.replace_filter(filter.to_sym, filter_text.chomp).dup)
    parameters = build_link_for(parameters)
    parameters = blk.call(parameters) if blk
    @link_builder.call(parameters)
  end

  def add_filter(filter, filter_text, &blk)
    parameters = @search.filters_applied(filter.to_sym, filter_text.chomp).dup
    parameters = blk.call(parameters) if blk
    parameters = build_link_for(parameters)
    @link_builder.call(parameters)
  end

  def self.all_categories
    YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_categories.yml' ) ) ) )
  end

  private

  def parse_path_positions
    @sections = []
    @path_positions.split('/').each do |format|
      next if format.nil?
      section = { format: format }
      if /:\w+:(?<separator>[^:\/]*)/ =~ format
        section[:separator] = separator
        section[:fields] = format.scan(/:\w+:/).map { |field| field.to_s[1..-2] }
      end
      @sections.push(section)
    end
  end

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

    def from_newest?
      /^\/novidades(\/)*/ =~ @path
    end

    def from_selections?
      /^\/selecoes(\/)*/ =~ @path
    end

    def parse_brands_params
      %r{^/marcas(?:/(?<parameters>[^\?]+))?(?:/?\?(?<query>.*))?} =~ @path
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_collections_params
      %r{^/colecoes/(?<collection_theme>[^/\?]*)(?:/(?<parameters>[^\?]+))?(?:/?\?(?<query>.*))?} =~ @path
      @params[:collection_theme] = URI.decode(collection_theme.to_s)
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_catalogs_params
      /^(?:\/catalogo)?\/(?<category>[^\/\?]*)(?:\/(?<parameters>[^\?]+))?(?:\/?\?(?<query>.*))?/ =~ @path
      @params[:category] = URI.decode(category.to_s)
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_olooklet_params
      /^\/olooklet(?:\/(?<parameters>[^\?]+)?)?((?:\?(?<query>.*))?)?/ =~ @path
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_newest_params
      /^\/novidades(?:\/(?<parameters>[^\?]+)?)?((?:\/?\?(?<query>.*))?)?/ =~ @path
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end

    def parse_selections_params
      /^\/selecoes(?:\/(?<parameters>[^\?]+)?)?((?:\/?\?(?<query>.*))?)?/ =~ @path
      @params[:parameters] = URI.decode(parameters.to_s)
      @query = query
    end


    def build_link_for parameters
      other_parameters = @params.dup
      return_hash = {}
      return_hash[:brand] = parameters.delete(:brand).map{|b| b.parameterize }.join(MULTISELECTION_SEPARATOR) if parameters[:brand].present?
      return_hash[:subcategory] = ActiveSupport::Inflector.transliterate(parameters.delete(:subcategory).join(MULTISELECTION_SEPARATOR).downcase) if parameters[:subcategory].present?
      return_hash[:category] = ActiveSupport::Inflector.transliterate(parameters.delete(:category).first.to_s).downcase if parameters[:category].present?

      post_parameters = {}
      other_parameters.select{|k,v| PARAMETERS_WHITELIST.include?(k.to_s) }.each do |k,v|
        if k.to_s == "sort"
          v = VALUES.invert[v]
        end
        post_parameters[VALUES.invert[k.to_s]] = v.respond_to?(:join) ? v.join(MULTISELECTION_SEPARATOR) : v
      end

      filter_params = []
      parameters.each do |k, v|
        if v.respond_to?(:join)
          filter_params << "#{VALUES.invert[k.to_s]}-#{v.map{|_v| (_v =~ /heeluint/) ? _v.split(':').last.gsub("..","-") : ActiveSupport::Inflector.transliterate(_v).downcase}.join(MULTISELECTION_SEPARATOR)}" if v.present? && PARAMETERS_BLACKLIST.exclude?(k.to_s) && VALUES.invert[k.to_s]
        end
      end
      return_hash[:filter_params] = filter_params.join(FIELD_SEPARATOR)
      return_hash[:order_params] = post_parameters

      return_hash.delete(@current_key.to_sym) if @current_key
      path = [ return_hash[:category], return_hash[:brand], return_hash[:subcategory] ].flatten.select {|p| p.present? }.uniq.map{ |p| ActiveSupport::Inflector.transliterate(p).downcase }.join(MULTISELECTION_SEPARATOR)
      url = [path, return_hash[:filter_params]].reject { |p| p.blank? }.join('/')
      unless return_hash[:order_params].empty?
        url.concat('?')
        url.concat(return_hash[:order_params].map { |k,v| "#{k}=#{v}" } .join('&'))
      end
      url
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
      param_brand = @params[:parameters].to_s.split('/').first.to_s.parameterize
      sorted_brands = all_brands.sort do |a,b|
        b.size <=> a.size
      end
      brands = sorted_brands.select do |b|
        if /#{b.parameterize}/ =~ param_brand
          param_brand.slice!(/#{b.parameterize}/)
          true
        end
      end
      brands.join(MULTISELECTION_SEPARATOR) if brands.any?
    end

    def extract_subcategories
      subcategories_and_brands = @params[:parameters].to_s.split("/").first.split(MULTISELECTION_SEPARATOR) rescue []
      _all_subcategories = all_subcategories || []
      unless @params[:search]
        _all_subcategories -= CARE_PRODUCTS.map { |s| ActiveSupport::Inflector.transliterate(s) }
      end
      subcategories = (subcategories_and_brands.map { |s| ActiveSupport::Inflector.transliterate(s) } & _all_subcategories)
      subcategories.join(MULTISELECTION_SEPARATOR) if subcategories.any?
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
        auxs = item.split(MULTISELECTION_SEPARATOR)
        key = auxs.shift
        vals = auxs.join(MULTISELECTION_SEPARATOR)
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
