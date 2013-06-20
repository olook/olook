class SearchEngine

  attr_reader :current_page, :result

  def initialize attributes = {}
    @search = SearchUrlBuilder.new
    .for_term(attributes[:term])
    .with_category(attributes[:category])
    .with_subcategories(attributes[:subcategory])
    .with_color(attributes[:color])
    .with_brand(attributes[:brand])
    .with_heel(attributes[:heel])
    .with_care(attributes[:care])
    .with_price(attributes[:price])
    .grouping_by
  end

  def for_page page=nil
    @current_page = page.try(:to_i) || 1
    self
  end

  def next_page
    @current_page + 1
  end

  def previous_page
    @current_page - 1
  end

  def start_product
    @limit ? (@current_page - 1) * @limit : 0
  end

  def with_limit limit=50
    @limit = limit.to_i
    self
  end

  def filters_and_products
    url = @search.build_url_for(limit: 50, start: self.start_product)
    @result = fetch_result(url, parse_facets: true, parse_products: true)
  end

  def filters
    url = @search.build_filters_url
    @result = fetch_result(url, parse_facets: true)
  end

  def products
    url = @search.build_url_for(limit: 50, start: self.start_product)
    @result = fetch_result(url, {parse_products: true})
    @result.products
  end

  def pages
    (@result.hits["found"] / 100.0).ceil
  end

  def has_next_page?
    @current_page.to_i < self.pages
  end

  def has_previous_page?
    @current_page.to_i > 1
  end

  def range_values_for(filter)
    if /(?<min>\d+)\.\.(?<max>\d+)/ =~ self.search.expressions[filter].to_s
      { min: min, max: max }
    end
  end

  private
    def fetch_result(url, options = {})
      Rails.logger.debug("GET cloudsearch URL: #{url}")
      _response = Net::HTTP.get_response(url)
      SearchResult.new(_response, options)
    end
end
