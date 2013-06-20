class SearchUrlBuilder
  include ERB::Util
  MULTISELECTION_SEPARATOR = '-'

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  # BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"

  def initialize(base_url=SEARCH_CONFIG["search_domain"] + "/2011-02-01/search")
    @base_url = base_url
    @expressions = {}
    @facets = []
  end

  def for_term term
    @query = "q=#{CGI.escape term}" if term
    self
  end

  def with_subcategories subcategories
    @expressions["categoria"] ||= []
    @expressions["categoria"] = subcategories.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_category category
    @expressions["category"] ||= []
    @expressions["category"] = category.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_care care
    @expressions["care"] ||= []
    @expressions["care"] = care.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_brand brand
    @expressions["brand"] ||= []
    @expressions["brand"] = brand.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_heel heel
    @expressions["heel"] ||= []
    @expressions["heel"] = heel.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_size size
    @expressions["size"] ||= []
    @expressions["size"] = size.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_color color
    @expressions["color"] ||= []
    @expressions["color"] = color.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def grouping_by
    @facets << "brand_facet"
    @facets << "categoria"
    @facets << "cor_filtro"
    @facets << "heel"
    @facets << "care"
    self
  end

  def build_url_for(options={})
    options[:start] ||= 0
    options[:limit] ||= 50
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "?#{@query}&" : "?"
    URI.parse("http://#{@base_url}#{q}#{bq}return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance&size=100&start=#{ options[:start] }&rank=-cor_e_marca&size=#{ options[:limit] }")
  end

  def build_filters_url
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    URI.parse("http://#{@base_url}?#{bq}")
  end

  private

    def build_boolean_expression
      bq = []
      @expressions.each do |field, values|
        vals = values.map { |v| "(field #{field} '#{CGI.escape v}')" }
        bq << ( vals.size > 1 ? "(or #{vals.join(' ')})" : vals.first )
      end
      if bq.size == 1
        "bq=#{url_encode bq.first}&"
      elsif @expressions.size > 1
        "bq=#{url_encode "(and #{bq.join(' ')})"}&"
      else
        ""
      end
    end
end
