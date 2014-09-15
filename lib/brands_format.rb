class BrandsFormat
  ACCENTED_LOWERCASE_CHARS = 'áéíóúâêîôûàèìòùäëïöüãõñç'
  ACCENTED_UPPERCASE_CHARS = 'ÁÉÍÓÚÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÃÕÑÇ'

  LOWERCASE_CHARS = "abcdefghijklmnopqrstuvwxyz#{ACCENTED_LOWERCASE_CHARS}"
  UPPERCASE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ#{ACCENTED_UPPERCASE_CHARS}"
  def initialize
    @brands = get_sort_brands_from_cache
  end

  def retrieve_brands
    split_columns || []
  end
  private

  def separate_by_capital_letter
    formated_brands = {}
    @brands.select{|b| SeoUrl.all_brands.include? b }.each do |b|
      index = (b[0] =~ /[A-Z]/i) ? b[0].upcase : "0-9"
      formated_brands[index] ||= []
      formated_brands[index] << b
      formated_brands[index].sort!
    end
    formated_brands
  end

  def split_columns
    brands = separate_by_capital_letter 
    brands.each_slice((brands.keys.size/4.0).ceil).to_a if brands.any?
  end

  def get_sort_brands_from_cache
    sitemap = redis.get("sitemap")
    if sitemap
      ActiveSupport::JSON.decode(sitemap)["brands"].map{|brand| brand.tr(UPPERCASE_CHARS, LOWERCASE_CHARS).titleize}.uniq.sort
    else 
      []
    end
  end

  def redis
    Redis.connect(url: ENV['REDIS_SITEMAP'])
  end
end
