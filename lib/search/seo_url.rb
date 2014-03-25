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

    @params = HashWithIndifferentAccess.new(optionals[:params])
    @path = optionals[:path] || ''
    @path_positions = optionals[:path_positions] || DEFAULT_POSITIONS
  end

  def set_link_builder(&blk)
    @link_builder = blk
  end

  def parse_params
    @parsed_values = HashWithIndifferentAccess.new
    parse_path_positions
    parse_path_into_sections
    parse_query

    @parsed_values[:collection_theme] ||= @params[:collection_theme]
    @parsed_values[:visibility] ||= @params[:visibility]

    @parsed_values.merge!(parse_order)
    @parsed_values
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

  ['color', 'size', 'heel', 'care'].each do |f|
    define_method "extract_#{f}" do |path_section|
      parse_filters(path_section)[f]
    end
  end

  def parse_path_into_sections
    index = 0
    path, @query = @path.split('?')
    path.split('/').each do |path_section|
      next if path_section.blank?
      index += 1 if recursive_section_parse(path_section.dup, index)
    end
  end

  def recursive_section_parse(path_section, index)
    return true if @sections[index].nil?
    ( index .. ( @sections.size - 1 ) ).to_a.any? do |i|
      section_parse(path_section.dup, @sections[i])
    end
  end

  def section_parse(path_section, section)
    return true if section[:fields].blank?
    section_proceseed = false
    section[:fields].each do |field|
      begin
        processed = send("extract_#{field}", path_section.dup)
        if !processed.blank?
          @parsed_values[field] = processed
          section_proceseed = true
        end
      rescue NoMethodError
        puts "Method extract_#{field} does not exist. Create it please"
      end
    end
    section_proceseed
  end

  def extract_collection_theme(path_section)
    path_section.to_s
  end

  def parse_path_positions
    @sections = []
    @path_positions.split('/').each do |format|
      next if format.blank?
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

  def extract_brand(path_section)
    param_brand = path_section

    sorted_brands = all_brands.sort do |a,b|
      b.size <=> a.size
    end

    brands = sorted_brands.select do |b|
      if /#{b.parameterize}/ =~ param_brand
        param_brand.slice!(/#{b.parameterize}/)
        true
      end
    end

    brands = brands.join(MULTISELECTION_SEPARATOR) if brands.any?
    brands
  end

  def extract_category(path_section)
    param_category = path_section

    _categories = all_categories.select do |c|
      if /#{c.parameterize}/ =~ param_category
        param_category.slice!(/#{c.parameterize}/)
        true
      end
    end
    _categories = _categories.join(MULTISELECTION_SEPARATOR) if _categories.any?
    _categories
  end

  def extract_subcategory(path_section)
    param_subcategory = path_section
    _subcategories = all_subcategories.select do |c|
      if CARE_PRODUCTS.include?(c)
        false
      elsif /#{c.parameterize}/ =~ param_subcategory
        param_subcategory.slice!(/#{c.parameterize}/)
        true
      end
    end
    _subcategories = _subcategories.join(MULTISELECTION_SEPARATOR) if _subcategories.any?
    _subcategories
  end

  def all_categories
    cat = YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_categories.yml' ) ) ) )
    cat = cat.keys
    cat.concat( cat.map { |s| s.downcase } )
    cat.concat( cat.map { |s| ActiveSupport::Inflector.transliterate(s) } )
    cat.concat( cat.map { |s| s.parameterize } )
    cat
  end

  def parse_filters(path_section)
    filter_params = path_section
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
