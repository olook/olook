require 'active_support/inflector'
class SearchEngine
  include Search::Paginable

  MULTISELECTION_SEPARATOR = '-'
  RANGED_FIELDS = HashWithIndifferentAccess.new({'price' => '', 'heel' => '', 'inventory' => ''})
  IGNORE_ON_URL = Set.new(['inventory', :inventory, 'is_visible', :is_visible, 'in_promotion', :in_promotion])
  PERMANENT_FIELDS_ON_URL = Set.new([:is_visible, :inventory])

  RETURN_FIELDS = [:subcategory,:name,:brand,:image,:retail_price,:price,:backside_image,:category,:inventory]

  SEARCHABLE_FIELDS = [:category, :subcategory, :color, :brand, :heel,
                :care, :price, :size, :product_id, :collection_theme,
                :sort, :term, :visibility]
  SEARCHABLE_FIELDS.each do |attr|
    define_method "#{attr}=" do |v|
      @expressions[attr] = v
    end
  end

  NESTED_FILTERS = {
    category: [ :subcategory ]
  }

  DEFAULT_SORT = "age,-inventory"

  attr_accessor :skip_beachwear_on_clothes
  attr_accessor :df

  attr_reader :current_page, :result
  attr_reader :expressions, :sort_field

  def initialize attributes = {}, opts={}
    @return_fields = Search::Query::ReturnFields.factory.new(RETURN_FIELDS)
    @expressions = HashWithIndifferentAccess.new
    @expressions['is_visible'] = [1]
    @expressions['inventory'] = ['inventory:1..']
    @expressions['in_promotion'] = [0]
    @expressions['visibility'] = [Product::PRODUCT_VISIBILITY[:site],Product::PRODUCT_VISIBILITY[:all]]
    @term = Search::Query::Term.factory.new
    @facets = Search::Query::Facets.factory.new
    default_facets
    @skip_beachwear_on_clothes = !!opts[:skip_beachwear_on_clothes]
    @is_smart = !!opts[:is_smart]
    @multi_selection = !!opts[:multi_selection]

    Rails.logger.debug("SearchEngine received these params: #{attributes.inspect}")
    @current_page = 1
    set_attributes(attributes)

    validate_sort_field
    Rails.logger.debug("SearchEngine processed these params: #{@expressions.inspect}")

    @redis = Redis.connect(url: ENV['REDIS_CACHE_STORE'])
  end

  def term= term
    @term.value = term
  end

  def term
    @term.value
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
    if price.to_s =~ /^(-?\d+-\d+)+$/
      pvals = price.split('-')
      while pvals.present?
        val_arr = pvals.shift(2)
        @expressions["price"] << "retail_price:#{val_arr.first}..#{val_arr.last}"
      end
    end
    self
  end

  def sort= sort_field
    @sortables ||= Set.new(['retail_price', '-retail_price', 'desconto', '-desconto','age'])
    if sort_field.present? && @sortables.include?(sort_field)
      @is_smart = false
      @sort_field = "#{ sort_field }"
    end

    self
  end

  def page=(val)
    for_page(val)
  end

  def limit=(val)
    with_limit(val)
  end

  def admin=(val)
    for_admin if val
  end

  def category= _category
    if _category == "roupa" && !@skip_beachwear_on_clothes
      @expressions["category"] = ["roupa","moda-praia", "lingerie"]
    elsif _category.is_a?(Array) 
      @expressions["category"] = _category.map { |c| c.parameterize }
    elsif _category == 'plus-size'
      @expressions["category"] = [_category]
    else
      @expressions["category"] = _category.to_s.parameterize
    end
  end

  def total_results
    @result.hits["found"] || 0
  end

  def cache_key
    key = build_url_for(limit: @limit, start: self.start_item)
    Digest::SHA1.hexdigest(df.to_s + "/" + key.to_s)
  end

  def filters_applied(filter_key, filter_value)
    filter_value = ActiveSupport::Inflector.transliterate(filter_value).downcase
    filter_params = append_or_remove_filter(filter_key, filter_value, formatted_filters)
    filter_params
  end

  def remove_filter filter
    parameters = formatted_filters
    parameters.delete_if {|k| IGNORE_ON_URL.include? k }
    parameters[filter.to_sym] = []
    if NESTED_FILTERS[filter.to_sym]
      NESTED_FILTERS[filter.to_sym].each do |key|
        parameters[key.to_sym] = []
      end
    end
    parameters
  end

  def replace_filter(filter, filter_value)
    parameters = formatted_filters
    parameters.delete_if {|k| IGNORE_ON_URL.include? k }
    parameters[filter.to_sym] = [filter_value]
    if NESTED_FILTERS[filter.to_sym]
      NESTED_FILTERS[filter.to_sym].each do |key|
        parameters[key.to_sym] = []
      end
    end
    parameters
  end

  def current_filters
    parameters = formatted_filters
    parameters.delete_if {|k| IGNORE_ON_URL.include? k }
    parameters
  end

  def filters(options={})
    @filters_result ||= {}
    url = build_filters_url(options)
    @filters_result[url] ||= -> {
      f = fetch_result(url, parser: SearchedProduct, parse_facets: true)
      f.set_groups('subcategory', subcategory_without_care_products(f))
      f
    }.call
  end

  def products(pagination = true)
    url = build_url_for(pagination ? {limit: @limit, start: self.start_item} : {})
    @result ||= fetch_result(url, parser: SearchedProduct, parse_products: true)
    @result.products
  end

  def range_values_for(filter)
    if /(?<min>\d+)\.\.(?<max>\d+)/ =~ expressions[filter].to_s
      { min: min.to_d.round.to_s, max: max.to_d.round.to_s }
    end
  end

  def filter_value(filter)
    normalize_values(expressions[filter]) if expressions[filter]
  end

  def filter_selected?(filter_key, filter_value)
    if values = expressions[filter_key]
      values = normalize_values(values)
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
    if category == "price"
      return price_selected_filters expressions
    else
      return normalize_values(expressions[category.to_sym] || [])
    end
  end

  def has_any_filter_selected?
    _filters = expressions.clone
    _filters.delete(:category)
    _filters.delete(:price)
    _filters.delete_if{|k,v| IGNORE_ON_URL.include?( k )}
    _filters.delete_if{|k,v| v.empty?}
    _filters.values.flatten.any?
  end

  def build_filters_url(options={})
    bq = build_boolean_expression(options)
    Search::Url.new(structured: bq, facets: @facets,
                    term: @term, size: '0',
                    'return-fields' => Search::Query::ReturnFields.factory.new('_no_fields')).url
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
    @facets.set_top_for('brand_facet', 100)
    self
  end

  def build_url_for(options={})
    options[:start] ||= 0
    options[:limit] ||= 50
    bq = build_boolean_expression

    @sort = Search::Query::Sort.factory.new
    if @is_smart
      @sort.add_ranking("exp", "r_inventory+r_brand_regulator+r_age")
      @sort.use("-exp", *@sort_field.to_s.split(",").reject{|v| v.blank?})
    else
      @sort.use(*@sort_field.to_s.split(",").reject{|v| v.blank?})
    end

    url = Search::Url.new(structured: bq, term: @term,
                          "return-fields" => @return_fields, sort: @sort,
                          start: options[:start], size: options[:limit])
    url.url
  end

  def fetch_result(url, options = {})
    Search::Retriever.new(redis: @redis, logger: Rails.logger).fetch_result(url, options)
  end

  def build_boolean_expression(options={})
    expressions = @expressions.clone
    structured = SearchedProduct.structured(:and)
    cares = normalize_values(expressions.delete('care'))
    if cares.present?
      subcategories = normalize_values(expressions.delete('subcategory'))
      vals = cares.map { |v| ["care", v] }
      vals.concat(subcategories.map { |v| ["subcategory", v] }) if subcategories.present?
      if vals.size > 1
        structured.or do |s|
          vals.each do |k, v|
            s.field(k, v)
          end
        end
      else
        structured.or(*vals.first)
      end
    end

    expressions.each do |field, values|
      values = normalize_values(values)
      next if ( options[:multi_selection] || @multi_selection ) && options[:use_fields] &&
        !options[:use_fields].include?(field.to_sym) &&
        PERMANENT_FIELDS_ON_URL.exclude?(field.to_sym)
      next if values.select { |v| v.present? }.empty?

      if RANGED_FIELDS[field]
        structured.or do |s|
          values.each do |value|
            k, r = value.split(':')
            min,max = r.split('..')
            s.field(k, [min,max])
          end
        end
        next
      end

      if values.size > 1
        structured.or do |s|
          values.each do |v|
            s.field field, v
          end
        end
      else
        structured.field field, values.first
      end
    end

    structured
  end

  def subcategory_without_care_products(filters)
    _filters = filters.grouped_products('subcategory')
    _filters.delete_if{|c| Product::CARE_PRODUCTS.map(&:parameterize).include?(c.parameterize) } if _filters
    _filters
  end

  def key_for field
    chosen_filter_values = expressions[field.to_sym] || []
    # Use Digest::SHA1.hexdigest ??
    key = expressions[:category].to_a.join("-") + "/" + field.to_s + "/" + chosen_filter_values.join("-")
    Rails.logger.info "[cloudsearch] #{field}_key=#{key}"
    key
  end

  private

  def normalize_values(vals)
    if @multi_selection
      values = vals.split(MULTISELECTION_SEPARATOR) if vals.respond_to?(:split)
    else
      values = [vals].flatten.compact
    end
    values
  end

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
    expressions.clone.each do |k, v|
      v = normalize_values(v)
      next if IGNORE_ON_URL.include?(k)
      next if k == 'visibility'
      filter_params[k] ||= []
      if RANGED_FIELDS[k]
        v.each do |_v|
          /(?<min>\d+)\.\.(?<max>\d+)/ =~ _v.to_s
          filter_params[k] << "#{min}-#{max}"
        end
      else
        filter_params[k].concat v.map { |_v| _v.downcase }
      end
    end
    filter_params[:sort] = ( @sort_field == DEFAULT_SORT ? nil : @sort_field )
    filter_params[:term] = ( @term.value ) if @term
    filter_params[:page] = ( current_page ) if current_page != 1

    filter_params
  end

  def validate_sort_field
    if @sort_field.nil? || @sort_field == "" || @sort_field == 0 || @sort_field == "0"
      @sort_field = DEFAULT_SORT
    end
  end

  def price_selected_filters expressions
    return [] unless expressions[:price]
    price_filters = expressions[:price].map do |e| 
      a = e.gsub("retail_price:","").split("..")
      a.join("-")
    end
    normalize_values(price_filters || [])
  end

  def set_attributes(attributes)
    attributes.each do |k, v|
      next if k.blank?
      begin
        self.send("#{k}=", v)
      rescue NoMethodError
      end
    end
  end
end
