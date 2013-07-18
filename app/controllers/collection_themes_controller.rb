# -*- encoding : utf-8 -*-
class CollectionThemesController < SearchController
  layout "lite_application"

  def index
    @featured_products = retrieve_featured_products
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  def show
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    params.merge!(SeoUrl.parse(params[:parameters], params))
    Rails.logger.debug("New params: #{params.inspect}")

    @filters = create_filters #TODO use SearchEngine#filters instead create new filters

    @search = SearchEngine.new(category: params[:category],
                               care: params[:care],
                               subcategory: params[:subcategory],
                               color: params[:color],
                               heel: params[:heel],
                               care: params[:care],
                               price: params[:price],
                               size: params[:size],
                               collection_themes: params[:collection_theme],
                               sort: params[:sort]).for_page(params[:page]).with_limit(48)
    @collection_theme = CollectionTheme.find_by_slug(params[:collection_theme])
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  private

    # TODO: Lógica duplicada no model payment onde usa o Product#featured_products
    def retrieve_featured_products
      products = Setting.collection_section_featured_products.split('#')
      products_models = Product.where(id: products.map { |p| p.split('|').last.to_i}).all
      products.map! do |pair|
        values = pair.split('|')
        product = products_models.find { |p| p.id == values[1].to_i }
        if product
          {
            label: values[0],
            product: product
          }
        else
          nil
        end
      end
      products.compact!
      products.select {|h| h[:product].inventory_without_hiting_the_database > 0}
    end

end
