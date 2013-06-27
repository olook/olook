require 'active_support/inflector'
class SearchEngine

  attr_reader :current_page, :result

  def initialize attributes = {}
    Rails.logger.debug("SearchEngine received these params: #{attributes.inspect}")
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
    .sort_by(attributes[:sort])
    .grouping_by

    @search
  end

  def for_admin
    @search.for_admin
  end

  def filters_applied(filter_key, filter_value)
    filter_params = HashWithIndifferentAccess.new
    filter_value = ActiveSupport::Inflector.transliterate(filter_value).downcase
    @search.expressions.each do |k, v|
      next if SearchUrlBuilder::IGNORE_ON_URL[k]
      filter_params[k] ||= []
      if SearchUrlBuilder::RANGED_FIELDS[k]
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
    url = build_filters_url
    @result = fetch_result(url, parse_facets: true)
  end

  def products(pagination = true)
    url = build_url_for(pagination ? {limit: @limit, start: self.start_product} : {})
    @result = fetch_result(url, {parse_products: true})
    @result.products
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
    if /(?<min>\d+)\.\.(?<max>\d+)/ =~ @search.expressions[filter].to_s
      { min: (min.to_d/100.0).round.to_s, max: (max.to_d/100.0).round.to_s }
    end
  end

  def filter_value(filter)
    @search.expressions[filter]
  end

  def filter_selected?(filter_key, filter_value)
    if values = @search.expressions[filter_key]
      if SearchUrlBuilder::RANGED_FIELDS[filter_key]
        values.any? do |v|
          /#{filter_value.gsub('-', '..')}/ =~ v
        end
      else
        values.map{|_v| _v.titleize}.include?(ActiveSupport::Inflector.transliterate(filter_value).titleize)
      end
    else
      false
    end
  end

  def selected_filters_for category
    @search.expressions[category.to_sym] || []
  end

  def has_any_filter_selected?
    _filters = @search.expressions.dup
    _filters.delete(:category)
    _filters.delete(:price)
    _filters.delete_if{|k,v| SearchUrlBuilder::IGNORE_ON_URL[k]}
    _filters.values.flatten.any?
  end

  def current_page
    @current_page
  end

  private

    def build_filters_url
      @search.build_filters_url
    end

    def build_url_for(options)
      @search.build_url_for(options)
    end

    def fetch_result(url, options = {})
      tstart = Time.zone.now.to_f
      _response = Net::HTTP.get_response(url)
      Rails.logger.info("GET cloudsearch URL (#{'%0.5fs' % ( Time.zone.now.to_f - tstart )}): #{url}")
      SearchResult.new(_response, options)
    end
end
