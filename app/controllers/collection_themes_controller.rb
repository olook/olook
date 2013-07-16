# -*- encoding : utf-8 -*-
class CollectionThemesController < ApplicationController
  layout "lite_application"

  def index
    @featured_products = retrieve_featured_products
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  def show
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @search = SearchEngine.new(params).for_page(params[:page]).with_limit(48)
    @collection_theme = CollectionTheme.find_by_name(params[:collection_theme])
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
