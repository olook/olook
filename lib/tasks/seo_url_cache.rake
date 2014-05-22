# encoding: utf-8
namespace :seo_url do
  desc 'Criar os arquivos de cache para comparação do SeoUrl'
  task :cache_all => :environment do
    subcategories = Detail.where(translation_token: 'categoria').group(:description).pluck(:description).flatten.uniq

    categories = Product.joins(:details).
      select("products.category, details.description").
      where("details.translation_token = ?", 'categoria').
      group('products.category, details.description').
      all.inject({}) do |k,v|
      c = Category.t(v['category'].to_i)
      k[c] ||= []
      k[c].push(v['description']).uniq!
      k[c].compact!
      k
    end

    brands = Product.all.map(&:brand).compact.map do |b|
      b
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
