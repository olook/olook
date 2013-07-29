module BrandsHelper
  def brand_filter_link_to brand
    brand = ActiveSupport::Inflector.transliterate(brand.chomp).downcase
    brand_path(brand)
  end
end
