require 'active_support/inflector'
class SearchEngine
  MULTISELECTION_SEPARATOR = '-'

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"
  RANGED_FIELDS = HashWithIndifferentAccess.new({'price' => '', 'heel' => '', 'inventory' => ''})
  IGNORE_ON_URL = HashWithIndifferentAccess.new({'inventory' => '', 'is_visible' => ''})
  FIELDS_FOR = [:category, :subcategory, :color, :brand, :heel,
                :care, :price, :size, :product_ids, :collection_theme,
                :sort, :term]
  PERMANENT_FIELDS_ON_SEARCH = Set.new([:is_visible, :inventory])
  FIELDS_FOR.each do |attr|
    define_method "#{attr}=" do |v|
      @expressions[attr] = v.to_s.split(MULTISELECTION_SEPARATOR)
    end
  end

  attr_reader :current_page, :result
  attr_reader :expressions, :sort_field

  def initialize attributes = {}
    @expressions = HashWithIndifferentAccess.new
    @expressions['is_visible'] = [1]
    @expressions['inventory'] = ['inventory:1..']
    @facets = []
    default_facets

    Rails.logger.debug("SearchEngine received these params: #{attributes.inspect}")
    @current_page = 1
    attributes.each do |k, v|
      next if k.blank?
      self.send("#{k}=", v)
    end
  end

  def term= term
    @query = URI.encode(term) if term
  end

  def cache_key
    key = build_url_for(limit: @limit, start: self.start_product)
    Digest::SHA1.hexdigest(key.to_s)
  end

  def filters_applied(filter_key, filter_value)
    filter_params = HashWithIndifferentAccess.new
    filter_value = ActiveSupport::Inflector.transliterate(filter_value).downcase
    expressions.each do |k, v|
      next if IGNORE_ON_URL[k]
      filter_params[k] ||= []
      if RANGED_FIELDS[k]
        v.each do |_v|
          /(?<min>\d+)\.\.(?<max>\d+)/ =~ _v.to_s
          if k.to_s == 'price'
            min = (min.to_d / 100.0).round
            max = (max.to_d / 100.0).round
          end
          filter_params[k] << "#{min}-#{max}"
        end
      else
        filter_params[k].concat v.map { |_v| _v.downcase }
      end
    end

    if filter_params[filter_key]
      if filter_selected?(filter_key, filter_value)
        filter_params[filter_key] -= [ filter_value.downcase ]
      else
        filter_params[filter_key] << filter_value.downcase
      end
      filter_params[filter_key].uniq!
    else
      filter_params[filter_key] = [filter_value.downcase]
    end

    filter_params
  end

  def remove_filter filter
    parameters = expressions.dup
    parameters.delete_if {|k| IGNORE_ON_URL.include? k }
    parameters[filter.to_sym] = []
    parameters
  end

  def current_filters
    parameters = expressions.dup
    parameters.delete_if {|k| IGNORE_ON_URL.include? k }
    parameters
  end

  def for_page page
    @current_page = (page || 1).to_i
    self
  end

  def next_page
    current_page + 1
  end

  def previous_page
    current_page - 1
  end

  def start_product
    @limit ? (@current_page - 1) * @limit : 0
  end

  def with_limit limit=48
    @limit = limit ? limit.to_i : 48
    self
  end

  def filters(options={})
    url = build_filters_url(options)
    if @last_url == url && @result
      return @result
    end
    @last_url = url
    @result = fetch_result(@last_url, parse_facets: true)

    remove_care_products_from(@result)
    @result
  end

  def products(pagination = true)
    url = build_url_for(pagination ? {limit: @limit, start: self.start_product} : {})
    if @last_url == url && @result.try(:products)
      return @result.products
    end
    @last_url = url
    @result = fetch_result(@last_url, {parse_products: true})
    @result.products
  rescue => e
    Rails.logger.error("ERROR #{e.class} (#{e.message}) on searching in cloud search url: #{url || ''}\n#{e.backtrace.join("\n")}")
    []
  end

  def pages
    (@result.hits["found"] / @limit.to_f).ceil
  end

  def next_pages
    _page = @current_page
    pages = []
    2.times do |page|
      page = _page + 1
      pages << page
      _page = _page + 1
    end
    pages.delete_if {|v| v >= self.pages}
  end

  def previous_pages
    _page = @current_page
    pages = []
    2.times do |page|
      page = _page - 1
      pages << page
      _page = _page - 1
    end
    pages.reverse.delete_if {|v| v <= 0}
  end

  def current_page_greater_than_limit_link_pages?
    current_page > 4
  end

  def current_page_greater_or_eq_than_limit_link_pages?
    current_page >= 4
  end

  def last_three_pages
    current_page - 3
  end

  def next_three_pages
    current_page + 3
  end

  def has_next_page?
    current_page.to_i < self.pages
  end

  def has_previous_page?
    current_page.to_i > 1
  end

  def has_at_least_three_more_pages?
    current_page < (self.pages - 3)
  end

  def range_values_for(filter)
    if /(?<min>\d+)\.\.(?<max>\d+)/ =~ expressions[filter].to_s
      { min: (min.to_d/100.0).round.to_s, max: (max.to_d/100.0).round.to_s }
    end
  end

  def filter_value(filter)
    expressions[filter]
  end

  def filter_selected?(filter_key, filter_value)
    if values = expressions[filter_key]
      if RANGED_FIELDS[filter_key]
        values.any? do |v|
          /#{filter_value.gsub('-', '..')}/ =~ v
        end
      else
        values.map{|_v| ActiveSupport::Inflector.transliterate(_v).downcase.titleize}.include?(ActiveSupport::Inflector.transliterate(filter_value).downcase.titleize)
      end
    else
      false
    end
  end

  def selected_filters_for category
    expressions[category.to_sym] || []
  end

  def has_any_filter_selected?
    _filters = expressions.dup
    _filters.delete(:category)
    _filters.delete(:price)
    _filters.delete_if{|k,v| IGNORE_ON_URL[k]}
    _filters.values.flatten.any?
  end

  def current_page
    @current_page
  end

  def build_filters_url(options={})
    bq = build_boolean_expression(options)
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "q=#{@query}&" : ""
    "http://#{BASE_URL}?#{q}#{bq}"
  end


  def for_admin
    @expressions['is_visible'] = [0,1]
    @expressions['inventory'] = ['inventory:0..']
    self
  end

  def heel= heel
    @expressions["heel"] = []
    if heel =~ /^(-?\d+-\d+)+$/
      hvals = heel.split('-')
      while hvals.present?
        val = hvals.shift(2).join('..')
        @expressions["heel"] << "heeluint:#{val}"
      end
    end
    self
  end

  def price= price
    @expressions["price"] = []
    if /^(?<min>\d+)-(?<max>\d+)$/ =~ price.to_s
      @expressions["price"] = ["retail_price:#{min.to_i*100}..#{max.to_i*100}"]
    end
    self
  end

  def default_facets
    @facets << "brand_facet"
    @facets << "subcategory"
    @facets << "color"
    @facets << "heel"
    @facets << "care"
    @facets << "size"
    @facets << "category"
    @facets << 'collection_themes'
    self
  end

  def sort= sort_field
    @sort_field = "#{ sort_field }&" if sort_field.present?
    @sort_field ||= "-collection,-inventory,-text_relevance"
    self
  end

  def build_url_for(options={})
    options[:start] ||= 0
    options[:limit] ||= 50
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "?q=#{@query}&" : "?"
    "http://#{BASE_URL}#{q}#{bq}return-fields=subcategory,name,brand,image,retail_price,price,backside_image,category,text_relevance&start=#{ options[:start] }&rank=#{ @sort_field }&size=#{ options[:limit] }"
  end

  def fetch_result(url, options = {})
    url = URI.parse(url)
    tstart = Time.zone.now.to_f * 1000.0
    _response = Net::HTTP.get_response(url)
    Rails.logger.info("GET cloudsearch URL (#{'%0.5fms' % ( (Time.zone.now.to_f*1000.0) - tstart )}): #{url}")
    SearchResult.new(_response, options)
  end

  def build_boolean_expression(options={})
    bq = []
    expressions = @expressions.dup
    cares = expressions.delete('care')
    if cares.present?
      subcategories = expressions.delete('subcategory')
      vals = cares.map { |v| "(field care '#{v}')" }
      vals.concat(subcategories.map { |v| "(field subcategory '#{v}')" }) if subcategories.present?
      bq << ( vals.size > 1 ? "(or #{vals.join(' ')})" : vals.first )
    end
    expressions.each do |field, values|
      next if options[:use_fields] && !options[:use_fields].include?(field.to_sym) && PERMANENT_FIELDS_ON_SEARCH.exclude?(field.to_sym)
      next if values.empty?
      if RANGED_FIELDS[field]
        bq << "(or #{values.join(' ')})"
      elsif values.is_a?(Array) && values.any?
        vals = values.map { |v| "(field #{field} '#{v}')" } unless values.empty?
        bq << ( vals.size > 1 ? "(or #{vals.join(' ')})" : vals.first )
      end
    end

    if bq.size == 1
      "bq=#{ERB::Util.url_encode bq.first}&"
    elsif bq.size > 1
      "bq=#{ERB::Util.url_encode "(and #{bq.join(' ')})"}&"
    else
      ""
    end
  end

  def remove_care_products_from(filters)
    if filters.grouped_products('subcategory')
      filters.grouped_products('subcategory').delete_if{|c| Product::CARE_PRODUCTS.map(&:parameterize).include?(c.parameterize) }
    end
  end
end
