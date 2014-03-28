# encoding: utf-8
require 'active_support/inflector'
class SeoUrl

  KEYS_TRANSLATION = HashWithIndifferentAccess.new({
    "tamanho" => "size",
    "cor" => "color",
    "preco" => "price",
    "salto" => "heel",
    "colecao" => "collection",
    "por" => "sort",
    "novidade" => "age",
    "conforto" => "care",
    "colecao" => "collection",
    "por_pagina" => "per_page",
    "categoria" => "category",
    "modelo" => "subcategory",
    "marca" => "brand"
  })
  VALUES_TRANSLATION = HashWithIndifferentAccess.new({
    "menor-preco" => "retail_price",
    "maior-preco" => "-retail_price",
    "maior-desconto" => "-desconto",
    "novidade" => "age,-inventory,-text_relevance"
  })
  FIELDS_WITH_KEYS_IN_URL = Set.new(['color', 'size', 'heel', 'care'])
  CARE_PRODUCTS = [
    'Amaciante', 'Apoio plantar', 'Impermeabilizante', 'Palmilha', 'Proteção para calcanhar',
    'amaciante', 'apoio plantar', 'impermeabilizante', 'palmilha', 'proteção para calcanhar',
    'amaciante', 'apoio-plantar', 'impermeabilizante', 'palmilha', 'protecao-para-calcanhar'
  ]

  FIELD_SEPARATOR = '_'
  PARAMETERS_BLACKLIST = [ "price"]
  PARAMETERS_WHITELIST = [ "price", "sort", "per_page" ]
  MULTISELECTION_SEPARATOR = SearchEngine::MULTISELECTION_SEPARATOR
  DEFAULT_POSITIONS = '/:category:-:brand:-:subcategory:/:care:_:color:_:size:_:heel:'

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

  def set_params(k, v)
    @params[k] = v
  end

  def set_search(search)
    @search = search
  end

  def set_link_builder(&blk)
    @link_builder = blk
  end

  def parse_params
    @parsed_values = HashWithIndifferentAccess.new
    parse_path_positions
    parse_path_into_sections
    parse_query

    @params.each do |k, v|
      @parsed_values[k] = v
    end

    @parsed_values
  end

  def self.parse(*attrs)
    self.new(*attrs).parse_params
  end

  def current_filters(&blk)
    parameters = HashWithIndifferentAccess.new(@search.current_filters.dup)
    parameters = blk.call(parameters) if blk
    parameters = build_link_for(parameters)
    @link_builder.call(parameters)
  end

  def remove_filter_of(filter, &blk)
    parameters = HashWithIndifferentAccess.new(@search.remove_filter(filter.to_sym).dup)
    parameters = blk.call(parameters) if blk
    parameters = build_link_for(parameters)
    @link_builder.call(parameters)
  end

  def replace_filter(filter, filter_text, &blk)
    parameters = HashWithIndifferentAccess.new(@search.replace_filter(filter.to_sym, filter_text.chomp).dup)
    parameters = blk.call(parameters) if blk
    parameters = build_link_for(parameters)
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

  def build_link_for _parameters={}
    parameters = _parameters.dup
    parse_path_positions if @sections.blank?

    url = @sections.map do |section|
      build_path_string(parameters, section)
    end.compact

    query = build_query_string(parameters)

    full_path = "/#{url.join('/')}"
    full_path.concat("?#{query.join('&')}") if query.present?
    full_path
  end

  private

  def build_path_string(parameters, section)
    if section[:fields].blank?
      section[:format]
    else
      fields = section[:fields].map do |field|
        values = parameters.delete(field.to_sym)
        values = [@params[field.to_sym]].flatten if @params[field.to_sym]
        if values
          if FIELDS_WITH_KEYS_IN_URL.include?(field)
            v = "#{KEYS_TRANSLATION.invert[field.to_s]}#{section[:value_separator]}#{values.join(section[:value_separator])}"
          else
            v = values.join(section[:value_separator])
          end
          v.blank? ? nil : v
        end
      end.compact
      fields.join(section[:separator]) if fields.size > 0
    end
  end

  def build_query_string(parameters)
    parameters.map do |k, v|
      if k.present? && v.present?
        vs = [v].flatten.map do |_v|
          VALUES_TRANSLATION.invert[_v.to_s] ? VALUES_TRANSLATION.invert[_v.to_s] : _v.to_s
        end.compact

        if KEYS_TRANSLATION.invert[k.to_s]
          "#{KEYS_TRANSLATION.invert[k.to_s]}=#{vs.join(MULTISELECTION_SEPARATOR)}"
        else
          "#{k}=#{vs.join(MULTISELECTION_SEPARATOR)}"
        end
      end
    end.compact
  end

  ['color', 'size', 'heel', 'care'].each do |f|
    define_method "extract_#{f}" do |path_section, section|
      parse_filters(path_section, section)[f]
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
        processed = send("extract_#{field}", path_section.dup, section)
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

  def extract_collection_theme(path_section, section)
    path_section.to_s
  end

  def parse_path_positions
    @sections = []
    @path_positions.split('/').each do |format|
      next if format.blank?
      section = { format: format }
      if /^(?<value_separator>[^:])?(?::\w+:)+(?<separator>[^:])?$/ =~ format
        section[:separator] = separator
        section[:value_separator] = value_separator || separator
        section[:fields] = format.scan(/:\w+:/).map { |field| field.to_s[1..-2] }
      end
      @sections.push(section)
    end
  end

  def parse_query
    if @query.present?
      @query.split('&').each do |var|
        k, v = var.split('=').map { |i| URI.decode(i.to_s) }
        if KEYS_TRANSLATION[k]
          @parsed_values[KEYS_TRANSLATION[k]] = VALUES_TRANSLATION[v].present? ? VALUES_TRANSLATION[v] : v
        else
          @parsed_values[k] = VALUES_TRANSLATION[v].present? ? VALUES_TRANSLATION[v] : v
        end
      end
    end
  end

  def all_brands
    YAML.load( File.read( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_brands.yml' ) ) ) )
  end

  def extract_brand(path_section, section)
    param_brand = URI.decode(path_section).parameterize

    sorted_brands = all_brands.sort do |a,b|
      b.size <=> a.size
    end

    brands = []
    sorted_brands.each do |b|
      if /#{b.parameterize}/i =~ param_brand
        param_brand.slice!(/#{b.parameterize}/i)
        brands << b.parameterize(' ')
      end
    end

    brands = brands.join(section[:value_separator]) if brands.any?
    brands
  end

  def extract_category(path_section, section)
    param_category = path_section

    _categories = []
    all_categories.each do |c|
      _categories << param_category.slice!(/#{c.parameterize}/) if /#{c.parameterize}/ =~ param_category
    end
    _categories = _categories.join(section[:value_separator]) if _categories.any?
    _categories
  end

  def extract_subcategory(path_section, section)
    param_subcategory = path_section
    _subcategories = []
    all_subcategories.each do |c|
      if !CARE_PRODUCTS.include?(c) && /#{c.parameterize}/i =~ param_subcategory
        _subcategories << c.parameterize(' ')
        param_subcategory.slice!(/#{c.parameterize}/i)
      end
    end
    _subcategories = _subcategories.join(section[:value_separator]) if _subcategories.any?
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

  def parse_filters(path_section, section)
    filter_params = path_section
    parsed_values = {}
    filter_params.to_s.split(section[:separator]).each do |item|
      auxs = item.split(section[:value_separator])
      key = auxs.shift
      vals = auxs.join(section[:value_separator])
      parsed_values[KEYS_TRANSLATION[key]] = vals
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
