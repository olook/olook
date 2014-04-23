class BrandsFormat
  MINUSCULAS_COM_ACENTO = 'áéíóúâêîôûàèìòùäëïöüãõñç'
  MAIUSCULAS_COM_ACENTO = 'ÁÉÍÓÚÂÊÎÔÛÀÈÌÒÙÄËÏÖÜÃÕÑÇ'

  MINUSCULAS = "abcdefghijklmnopqrstuvwxyz#{MINUSCULAS_COM_ACENTO}"
  MAIUSCULAS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ#{MAIUSCULAS_COM_ACENTO}"
  def initialize
    @brands = get_sort_brands_from_cache
  end

  def retrieve_brands
    split_columns
  end
  private

  def separate_by_capital_letter
    formated_brands = {}
    @brands.each do |b|
      index = (b[0] =~ /[A-Z]/i) ? b[0].upcase : "0-9"
      formated_brands[index] ||= []
      formated_brands[index] << b
      formated_brands[index].sort!
    end
    formated_brands
  end
  def split_columns
    separate_by_capital_letter.each_slice(4).to_a
  end

  def get_sort_brands_from_cache
    ActiveSupport::JSON.decode(redis.get("sitemap"))["brands"].map{|brand| brand.tr(MAIUSCULAS, MINUSCULAS).titleize}.uniq.sort
  end

  def redis
    Redis.connect(url: ENV['REDIS_SITEMAP'])
  end
end
