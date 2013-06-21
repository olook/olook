require 'active_support/inflector'
class SeoUrl

  VALUES = {
    "tamanho" => "size",
    "cor" => "color",
    "preco" => "price",
    "salto" => "heel",
    "colecao" => "collection"
  }

  def self.parse parameters
    parsed_values = HashWithIndifferentAccess.new

    _all_brands = self.all_brands || []
    _all_subcategories = self.all_subcategories || []

    all_parameters = parameters.to_s.split("/")
    parsed_values[:category] = all_parameters.shift

    subcategories_and_brands = all_parameters.first.split("-") rescue []
    subcategories = []
    brands = []

    subcategories_and_brands.each do |sub|
      if _all_subcategories.include?(sub.titlecase)
        subcategories << sub
      end
    end

    subcategories_and_brands.each do |sub|
      if _all_brands.include?(sub.titlecase)
        brands << sub
      end
    end
    parsed_values[:subcategory] = subcategories.join("-") if subcategories.any?
    parsed_values[:brand] = brands.join("-") if brands.any?

    filter_params = all_parameters.last || []

    filter_params.split('_').each do |item|
      auxs = item.split('-')
      key = auxs.shift
      vals = auxs.join('-')
      parsed_values[VALUES[key]] = vals
    end

    parsed_values
  end

  def self.build params
    parameters = params.dup
    category = ActiveSupport::Inflector.transliterate(parameters.delete(:category).first.to_s).downcase
    subcategory = parameters.delete(:subcategory)
    brand = parameters.delete(:brand)

    path = [ subcategory, brand ].flatten.select {|p| p.present? }.uniq.map{ |p| ActiveSupport::Inflector.transliterate(p).downcase }.join('-')
    filter_params = []
    parameters.each do |k, v|
      if v.respond_to?(:join)
        filter_params << "#{VALUES.invert[k.to_s]}-#{v.map{|_v| ActiveSupport::Inflector.transliterate(_v).downcase}.join('-')}" if v.present?
      else
        filter_params << "#{VALUES.invert[k.to_s]}-#{ActiveSupport::Inflector.transliterate(v).downcase}" if v.present?
      end
    end
    filter_params = filter_params.join('_')
    { parameters: [category, path, filter_params].reject { |p| p.blank? }.join('/') }
  end

  private
    def self.all_subcategories
      Rails.cache.fetch CACHE_KEYS[:all_subcategories][:key], expire_in: CACHE_KEYS[:all_subcategories][:expire] do
        db_subcategories.map{ |s| [s.titleize, ActiveSupport::Inflector.transliterate(s.titleize)] }.flatten.uniq
      end
    end

    def self.db_subcategories
      Product.includes(:details).all.map(&:subcategory).compact
    end

    def self.all_brands
      Rails.cache.fetch CACHE_KEYS[:all_brands][:key], expire_in: CACHE_KEYS[:all_brands][:expire] do
        db_subcategories.map{ |b| [b.titleize, ActiveSupport::Inflector.transliterate(b.titleize)] }.flatten.uniq
      end
    end

    def self.db_brands
      Product.all.map(&:brand).compact
    end
end
