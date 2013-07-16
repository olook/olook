class SearchUrlBuilder
  include ERB::Util
  MULTISELECTION_SEPARATOR = '-'

  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  # BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"
  #
  attr_reader :expressions, :sort_field
  RANGED_FIELDS = HashWithIndifferentAccess.new({'price' => '', 'heel' => '', 'inventory' => ''})
  IGNORE_ON_URL = HashWithIndifferentAccess.new({'inventory' => '', 'is_visible' => ''})

  def initialize(base_url=SEARCH_CONFIG["search_domain"] + "/2011-02-01/search")
    @base_url = base_url
    @expressions = HashWithIndifferentAccess.new
    @expressions['is_visible'] = [1]
    @expressions['inventory'] = ['inventory:1..']

    @facets = []
  end

  def for_term term
    @query = "q=#{URI.encode term}" if term
    self
  end

  def for_admin
    @expressions['is_visible'] = [0,1]
    @expressions['inventory'] = ['inventory:0..']
    self
  end

  def with_subcategories subcategory
    @expressions["subcategory"] = subcategory.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_category category
    @expressions["category"] = category.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_care care
    @expressions["care"] = care.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_brand brand
    @expressions["brand"] = brand.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_collection_theme collection_theme
    @expressions["collection_themes"] = collection_theme.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_heel heel
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

  def with_product_ids ids
    @expressions["product_id"] = ids.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_size size
    @expressions["size"] = size.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_color color
    @expressions["color"] = color.to_s.split(MULTISELECTION_SEPARATOR)
    self
  end

  def with_price price
    @expressions["price"] = []
    if /^(?<min>\d+)-(?<max>\d+)$/ =~ price.to_s
      @expressions["price"] = ["retail_price:#{min.to_i*100}..#{max.to_i*100}"]
    end
    self
  end

  def grouping_by
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

  def sort_by sort_field
    @sort_field = "#{ sort_field }&" if sort_field.present?
    @sort_field ||= "-collection,-inventory,-text_relevance"
    self
  end

  def build_url_for(options={})
    options[:start] ||= 0
    options[:limit] ||= 50
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "?#{@query}&" : "?"
    URI.parse("http://#{@base_url}#{q}#{bq}return-fields=subcategory,name,brand,image,retail_price,price,backside_image,category,text_relevance&start=#{ options[:start] }&rank=#{ @sort_field }&size=#{ options[:limit] }")
  end

  def build_filters_url
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "#{@query}&" : ""
    URI.parse("http://#{@base_url}?#{q}#{bq}")
  end

  private

    def build_boolean_expression
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
        next if values.empty?
        if RANGED_FIELDS[field]
          bq << "(or #{values.join(' ')})"
        elsif values.is_a?(Array) && values.any?
          vals = values.map { |v| "(field #{field} '#{v}')" } unless values.empty?
          bq << ( vals.size > 1 ? "(or #{vals.join(' ')})" : vals.first )
        end
      end

      if bq.size == 1
        "bq=#{url_encode bq.first}&"
      elsif bq.size > 1
        "bq=#{url_encode "(and #{bq.join(' ')})"}&"
      else
        ""
      end
    end
end
