class SearchUrlBuilder
  include ERB::Util

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  # BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"

  def initialize base_url=SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"
    @base_url = base_url
    @expressions = []
  end

  def for_term term
    @query = "q=#{CGI.escape term}" if term
    self
  end

  def build_url_with attributes={}
    query = "q=#{CGI.escape @term}"
    query += "&bq=categoria%3A'#{CGI.escape attributes[:category]}'" if attributes[:category]
    query += "&bq=brand%3A'#{CGI.escape attributes[:brand]}'" if attributes[:brand]
    query += "&size=100"
    query += "&rank=-#{attributes[:rank]}" if attributes[:rank]
    URI.parse("http://#{BASE_URL}/2011-02-01/search?#{query}&return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance")
  end

  def with_category category
    @expressions << "categoria:'#{CGI.escape category}'"
    self
  end

  def with_brand brand
    @expressions << "brand:'#{CGI.escape brand}'"
    self
  end

  def build_url
    bq = build_boolean_query
    q = @query ? "?#{@query}&" : "?"
    URI.parse("http://#{@base_url}#{q}#{bq}return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance&size=100")
  end

  private

    def build_boolean_query
      if @expressions.size == 1
        "bq=#{url_encode(@expressions.first)}&"
      elsif @expressions.size > 1
        "bq=#{url_encode('(and ' + @expressions.join(" ") + ')')}&"
      else
        ""
      end
    end

end
