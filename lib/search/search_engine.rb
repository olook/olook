require 'active_support/inflector'
class SearchEngine
  include Search::Paginable
  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"

  MULTISELECTION_SEPARATOR = '-'
  RANGED_FIELDS = HashWithIndifferentAccess.new({'price' => '', 'heel' => '', 'inventory' => ''})
  IGNORE_ON_URL = Set.new(['inventory', :inventory, 'is_visible', :is_visible, 'in_promotion', :in_promotion, 'visibility', :visibility])
  PERMANENT_FIELDS_ON_URL = Set.new([:is_visible, :inventory])

  RETURN_FIELDS = [:subcategory,:name,:brand,:image,:retail_price,:price,:backside_image,:category,:text_relevance]

  SEARCHABLE_FIELDS = [:category, :subcategory, :color, :brand, :heel,
                :care, :price, :size, :product_id, :collection_theme,
                :sort, :term, :excluded_brand, :visibility]
  SEARCHABLE_FIELDS.each do |attr|
    define_method "#{attr}=" do |v|
      @expressions[attr] = v.to_s.split(MULTISELECTION_SEPARATOR)
    end
  end

  attr_accessor :skip_beachwear_on_clothes

  attr_reader :current_page, :result
  attr_reader :expressions, :sort_field

  def initialize attributes = {}, is_smart=false
    @expressions = HashWithIndifferentAccess.new
    @expressions['is_visible'] = [1]
    @expressions['inventory'] = ['inventory:1..']
    @expressions['in_promotion'] = [0]
    @expressions['visibility'] = [Product::PRODUCT_VISIBILITY[:site],Product::PRODUCT_VISIBILITY[:all]]
    @facets = []
    @is_smart = is_smart
    default_facets

    Rails.logger.debug("SearchEngine received these params: #{attributes.inspect}")
    @current_page = 1

    attributes.each do |k, v|
      next if k.blank?
      self.send("#{k}=", v)
    end

    validate_sort_field
  end

  def term= term
    @query = URI.encode(term) if term
  end

  # TODO: Mudar a forma que o recebe o collection_theme pois
  # o ideal é modificar o MULTISELECTION_SEPARATOR para ','
  # e passar a usar parameterize na indexação e mudar as urls.
  # Depende de fazer um tradutor dos links antigos para os novos.
  def collection_theme=(val)
    @expressions['collection_theme'] = [val.to_s] unless val.blank?
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

  def sort= sort_field
    @sortables ||= Set.new(['retail_price', '-retail_price', 'desconto', '-desconto','age'])
    if sort_field.present? && @sortables.include?(sort_field)
      @sort_field = "#{ sort_field }"
      @is_smart = false
    end
    self
  end


  def category= cat
    if cat == "roupa" && !@skip_beachwear_on_clothes
      @expressions["category"] = ["roupa","moda praia", "lingerie"]
    elsif cat.is_a? Array
      @expressions["category"] = cat
    else
      @expressions["category"] = cat.to_s.split(MULTISELECTION_SEPARATOR)
    end
  end

  def total_results
    @result.hits["found"]
  end

  def cache_key
    key = build_url_for(limit: @limit, start: self.start_item)
    Digest::SHA1.hexdigest(key.to_s)
  end

  def filters_applied(filter_key, filter_value)
    filter_value = ActiveSupport::Inflector.transliterate(filter_value).downcase
    filter_params = append_or_remove_filter(filter_key, filter_value, formatted_filters)
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

  def filters(options={})
    @filters_result ||= {}
    url = build_filters_url(options)
    @filters_result[url] ||= -> {
      f = fetch_result(url, parse_facets: true)
      f.set_groups('subcategory', subcategory_without_care_products(f))
      f
    }.call
  end

  def products(pagination = true)
    url = build_url_for(pagination ? {limit: @limit, start: self.start_item} : {})
    @result ||= fetch_result(url, {parse_products: true})
    @result.products
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
    _filters.delete_if{|k,v| IGNORE_ON_URL.include?( k )}
    _filters.delete_if{|k,v| v.empty?}
    _filters.values.flatten.any?
  end

  def build_filters_url(options={})
    bq = build_boolean_expression(options)
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "q=#{@query}&" : ""
    "http://#{BASE_URL}?#{q}#{bq}"
  end


  def for_admin
    @expressions['is_visible'] = [0,1]
    @expressions['in_promotion'] = [0,1]
    @expressions['inventory'] = ['inventory:0..']
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
    @facets << 'collection_theme'
    self
  end

  def build_url_for(options={})
    options[:start] ||= 0
    options[:limit] ||= 50
    bq = build_boolean_expression
    bq += "facet=#{@facets.join(',')}&" if @facets.any?
    q = @query ? "?q=#{@query}&" : "?"
    if @is_smart
      "http://#{BASE_URL}#{q}#{bq}return-fields=#{RETURN_FIELDS.join(',')}&start=#{ options[:start] }&#{ ranking }&rank=-exp,#{ @sort_field }&size=#{ options[:limit] }"
    else
      "http://#{BASE_URL}#{q}#{bq}return-fields=#{RETURN_FIELDS.join(',')}&start=#{ options[:start] }&rank=#{ @sort_field }&size=#{ options[:limit] }"
    end
  end

  def ranking
    "rank-exp=(r_full_grid*#{ Setting[:full_grid_weight].to_i })%2B(r_inventory*#{ Setting[:inventory_weight].to_i })%2B(r_qt_sold_per_day*#{ Setting[:qt_sold_per_day_weight].to_i })%2B(r_coverage_of_days_to_sell*#{ Setting[:coverage_of_days_to_sell_weight].to_i })%2B(r_age*#{ Setting[:age_weight].to_i })"
  end

  def fetch_result(url, options = {})
    cache_key = Digest::SHA1.hexdigest(url.to_s)
    Rails.logger.error "[cloudsearch] cache_key: #{cache_key}"

    _response = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      Rails.logger.error "[cloudsearch] cache missed"
      url = URI.parse(url)
      tstart = Time.zone.now.to_f * 1000.0
      _response = Net::HTTP.get_response(url)
      Rails.logger.error("GET cloudsearch URL (time=#{'%0.5fms' % ( (Time.zone.now.to_f*1000.0) - tstart )}): #{url}")
      _response
    end

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

    remove_excluded_brands(bq, expressions)
    expressions.each do |field, values|
      next if options[:use_fields] && !options[:use_fields].include?(field.to_sym) && PERMANENT_FIELDS_ON_URL.exclude?(field.to_sym)
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

  def subcategory_without_care_products(filters)
    _filters = filters.grouped_products('subcategory')
    _filters.delete_if{|c| Product::CARE_PRODUCTS.map(&:parameterize).include?(c.parameterize) } if _filters
    _filters
  end

  def key_for field
    if field.to_sym == :brand
      key = Digest::SHA1.hexdigest(expressions[:brand].to_s)
      Rails.logger.info "[cloudsearch] brand key=#{key}"
      key
    else
      ""
    end
  end

  private
    def append_or_remove_filter(filter_key, filter_value, filter_params)
      filter_params[filter_key] ||= [filter_value.downcase]
      if filter_selected?(filter_key, filter_value)
        filter_params[filter_key] -= [ filter_value.downcase ]
      else
        filter_params[filter_key] << filter_value.downcase
      end
      filter_params[filter_key].uniq!
      filter_params
    end

    def formatted_filters
      filter_params = HashWithIndifferentAccess.new
      expressions.each do |k, v|
        next if IGNORE_ON_URL.include?(k)
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

      filter_params
    end

    def remove_excluded_brands(bq, expressions)
      return unless expressions["excluded_brand"].present?
      excluded_brands = expressions["excluded_brand"]
      expressions.delete("excluded_brand")
      vals = excluded_brands.map { |v| "(field brand '#{v}')" } unless excluded_brands.empty?
      bq << ( "(not (or #{vals.join(' ')}))" )
    end

    def validate_sort_field
      if @sort_field.nil? || @sort_field == "" || @sort_field == 0 || @sort_field == "0"
        @sort_field = "age,-inventory,-text_relevance"
      end
    end
end
