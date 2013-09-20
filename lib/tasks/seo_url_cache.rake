# encoding: utf-8
namespace :seo_url do
  desc 'Criar os arquivos de cache para comparação do SeoUrl'
  task :cache_all => :environment do
    subcategories = Product.includes(:details).all.map(&:subcategory).compact.map do |s|
      [s.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize,
       ActiveSupport::Inflector.transliterate(s).gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize]
    end.flatten.uniq

    categories = Product.includes(:details).all.inject({}) do |k,v|
      k[v.category_humanize] ||= []
      k[v.category_humanize].push(v.subcategory).uniq!
      k[v.category_humanize].compact!
      k
    end

    brands = Product.all.map(&:brand).compact.map do |b|
      [b.gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize,
       ActiveSupport::Inflector.transliterate(b).gsub(/[\.\/\?]/, ' ').gsub('  ', ' ').strip.titleize]
    end.flatten.uniq

    File.open( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_categories.yml')), 'w') do |f|
      f.puts YAML.dump(categories)
    end

    File.open(File.expand_path(File.join(File.dirname(__FILE__), '../../config/seo_url_subcategories.yml')), 'w') do |f|
      f.puts YAML.dump(subcategories)
    end

    File.open(File.expand_path(File.join(File.dirname(__FILE__), '../../config/seo_url_brands.yml')), 'w') do |f|
      f.puts YAML.dump(brands)
    end
  end
end
