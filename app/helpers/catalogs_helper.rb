module CatalogsHelper
  def filter_link_to(path, field, text, amount=nil)
    filter_link = create_query_string_catalog(field => text.parameterize)
    text += " (#{amount})" if amount
    link_to text, path + "?#{filter_link}"
  end

  def build_link_path
    params[:category]
  end

  def filters_by filter
    @filters.grouped_products(filter)
  end

  private
    def create_query_string_catalog hash
      params = {q: @q, color: @color}
      params.merge! hash
      params.to_query
    end
end
