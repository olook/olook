class SearchUrlBuilder
  include ERB::Util

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  # BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"

  def initialize base_url=SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"
    @base_url = base_url
    @expressions = []
    @facets = []
  end

  def for_term term
    @query = "q=#{CGI.escape term}" if term
    self
  end

  def with_category category
    @expressions << "categoria:'#{CGI.escape category}'" unless category.nil? || category.empty?
    self
  end

  def with_brand brand
    @expressions << "brand:'#{CGI.escape brand}'" unless brand.nil? || brand.empty?
    self
  end

  def with_color color
    @expressions << "cor_filtro:'#{CGI.escape color}'" unless color.nil? || color.empty?
    self
  end

  def grouping_by
    @facets << "brand_facet"
    @facets << "categoria"
    @facets << "cor_filtro"
    self
  end

  def build_url
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "?#{@query}&" : "?"
    URI.parse("http://#{@base_url}#{q}#{bq}return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance&size=100&rank=-cor_e_marca")
  end



  private

    def build_boolean_expression
      if @expressions.size == 1
        "bq=#{url_encode(@expressions.first)}&"
      elsif @expressions.size > 1
        "bq=#{url_encode('(and ' + @expressions.join(" ") + ')')}&"
      else
        ""
      end
    end

end
