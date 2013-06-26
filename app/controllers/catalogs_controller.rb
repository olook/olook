# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  def show
    params.merge!(SeoUrl.parse(params[:parameters], params))
    Rails.logger.debug("New params: #{params.inspect}")

    @filters = create_filters

    @search = SearchEngine.new(category: params[:category],
                               subcategory: params[:subcategory],
                               color: params[:color],
                               heel: params[:heel],
                               care: params[:care],
                               price: params[:price],
                               size: params[:size],
                               brand: params[:brand],
                               sort: params[:sort]).for_page(params[:page]).with_limit(48)
    @catalog_products = @search.products
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
  end

  private
    def create_filters
      filters = SearchEngine.new(category: params[:category]).filters
      remove_care_products_from(filters)
      filters
    end

    def remove_care_products_from(filters)
      if filters.grouped_products('subcategory')
        filters.grouped_products('subcategory').delete_if{|c| Product::CARE_PRODUCTS.map(&:parameterize).include?(c.parameterize) }
      end
    end
end
