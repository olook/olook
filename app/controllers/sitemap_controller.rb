class SitemapController < ApplicationController
  layout "lite_application"
  def index
    prepare_sections_variables
  end

  private
  def prepare_sections_variables
    @url_builder = SeoUrl.new(search: SearchEngine.new)
    @brands = Product.only_visible.pluck(:brand).uniq.compact
    @collection_themes = CollectionTheme.active
    @shoes = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 1, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    @accessories = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 3, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    @bags = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 2, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
    @cloths = Detail.where(translation_token: 'Categoria').joins(:product).where(products: {category: 4, is_visible: true}).pluck(:description).map{|b| b.parameterize}.uniq
  end
end
