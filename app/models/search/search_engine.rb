require 'active_support/inflector'
class SearchEngine

  attr_reader :current_page, :result

  def initialize attributes = {}
    @current_page = 1
    @search = SearchUrlBuilder.new
    .for_term(attributes[:term])
    .with_category(attributes[:category])
    .with_subcategories(attributes[:subcategory])
    .with_color(attributes[:color])
    .with_brand(attributes[:brand])
    .with_heel(attributes[:heel])
    .with_care(attributes[:care])
    .with_price(attributes[:price])
    .with_size(attributes[:size])
    .sort_by_price(attributes[:sort_price])
    .grouping_by
  end

  def filters_applied(filter_key, filter_value)
    filter_params = HashWithIndifferentAccess.new
    filter_value = ActiveSupport::Inflector.transliterate(filter_value).downcase
    @search.expressions.each do |k, v|
      filter_params[k] ||= []
      if v.respond_to?(:join)
        filter_params[k].concat v
      else
        /(?<min>\d+)\.\.(?<max>\d+)/ =~ v.to_s
        filter_params[k] = "#{min}-#{max}"
      end
    end

    if filter_params[filter_key]
      if filter_params[filter_key].respond_to?(:join)
        if filter_selected?(filter_key, filter_value)
          filter_params[filter_key] -= [ filter_value ]
        else
          filter_params[filter_key] << filter_value
        end
        filter_params[filter_key].uniq!
      else
        /(?<min>\d+)\.\.(?<max>\d+)/ =~ filter_value.to_s
        filter_params[filter_key] = "#{min}-#{max}"
      end
    end

    filter_params
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

  def with_limit limit=50
    @limit = limit.to_i
    self
  end

  def filters
    url = @search.build_filters_url
    @result = fetch_result(url, parse_facets: true)
  end

  def products(pagination = true)
    url = @search.build_url_for(pagination ? {limit: @limit, start: self.start_product} : {})
    @result = fetch_result(url, {parse_products: true})
    @result.products
  end

  def pages
    (@result.hits["found"] / 100.0).ceil
  end

  def has_next_page?
    current_page.to_i < self.pages
  end

  def has_previous_page?
    current_page.to_i > 1
  end

  def range_values_for(filter)
    if /(?<min>\d+)\.\.(?<max>\d+)/ =~ @search.expressions[filter].to_s
      { min: min, max: max }
    end
  end

  def filter_value(filter)
    @search.expressions[filter]
  end

  def filter_selected?(filter_key, filter_value)
    if values = @search.expressions[filter_key]
      values.include?(ActiveSupport::Inflector.transliterate(filter_value).downcase)
    else
      false
    end
  end

  def selected_filters_for category
    @search.expressions[category.to_sym]
  end

  def has_any_filter_selected?
    _filters = @search.expressions.dup
    _filters.delete(:category)
    _filters.values.flatten.any?
  end

  private
    def fetch_result(url, options = {})
      Rails.logger.debug("GET cloudsearch URL: #{url}")
      _response = Net::HTTP.get_response(url)
      SearchResult.new(_response, options)
    end

    def current_page
      @current_page
    end
end
