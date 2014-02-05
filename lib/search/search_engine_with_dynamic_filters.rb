class SearchEngineWithDynamicFilters < SearchEngine
  
  # def initialize(attributes = {}, is_smart=false)
  #   super#(attributes, is_smart)
  # end

  def build_filters_url(options={})
    build_url_for(options)
  end

end