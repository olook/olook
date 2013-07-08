module BrandsHelper
  def brand_filter_link_to brand
    brand = ActiveSupport::Inflector.transliterate(brand.chomp).downcase
    "/marcas/#{brand}/#{default_category_for(brand)}"
  end

  private
    def default_category_for brand
      brand_categories_array = Brand.categories(brand)
      brand_categories_array.size > 1 ? "" : brand_categories_array.first.singularize 
    end
end