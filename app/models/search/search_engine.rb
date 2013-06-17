class SearchEngine

  attr_accessor :limit, :current_page, :search, :result

  def initialize attributes = {}
    self.search = SearchUrlBuilder.new
    .with_category(attributes[:category])
    .with_subcategory(attributes[:subcategory])
    .with_color(attributes[:color])
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
    (self.current_page - 1) * limit
  end

  def with_limit limit=50
    self.limit = limit.to_i
    self
  end

  def url
    self.search.build_url_for(self)
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

  private

    def fetch_result(url, options = {})
      _response = Net::HTTP.get_response(url)
      SearchResult.new(_response, options)
    end
end
