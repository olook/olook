class SearchEngine

  attr_accessor :limit, :current_page, :search, :result

  def initialize attributes = {}
    self.search = SearchUrlBuilder.new
    .for_term(attributes[:term])
    .with_category(attributes[:category])
    .with_subcategories(attributes[:subcategories])
    .with_color(attributes[:color])
    .with_brand(attributes[:brand])
    .with_heel(attributes[:heel])
    .with_care(attributes[:care])
    .with_price(attributes[:price])
    .grouping_by
  end

  def for_page page=nil
    self.current_page = page.try(:to_i) || 1
    self
  end

  def next_page
    self.current_page + 1
  end

  def previous_page
    self.current_page - 1
  end

  def start_product
    limit ? (self.current_page - 1) * limit : 0
  end

  def with_limit limit=50
    self.limit = limit.to_i
    self
  end

  def url
    self.search.build_url_for(limit: 50, start: self.start_product)
  end

  def filters_url
    self.search.build_filters_url
  end

  def filters
    self.result = fetch_result(self.filters_url, parse_facets: true)
  end

  def products
    self.result = fetch_result(self.url, {parse_products: true})
    self.result.products
  end

  def pages
    (self.result.hits["found"] / 100.0).ceil
  end

  def has_next_page?
    self.current_page.to_i < self.pages
  end

  def has_previous_page?
    self.current_page.to_i > 1
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
