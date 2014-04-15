class SitemapController < ApplicationController
  def index
    prepare_instance_variables
    @url_builder = SeoUrl.new(search: SearchEngine.new)
    # @brands = Product.only_visible.map{|p| ActiveSupport::Inflector.transliterate(p.brand).downcase.titleize if Brand.find_by_name ActiveSupport::Inflector.transliterate(p.brand).downcase.titleize}.uniq.compact
    # @brands = @search.filters.facets["brand_facet"]["constraints"].map{|s| s["value"]}
    @brands = Product.only_visible.pluck(:brand).uniq.compact
    @collection_themes = CollectionTheme.active
    @shoes = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 1, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    @accessories = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 3, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    @bags = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 2, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    @cloths = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 4, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
  end

  private
  def prepare_instance_variables
  end
end
