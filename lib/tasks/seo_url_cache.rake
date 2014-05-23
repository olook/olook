# encoding: utf-8
namespace :seo_url do
  desc 'Criar os arquivos de cache para comparação do SeoUrl'
  task :cache_all => :environment do
    def downcase_pronouns_this(str)
      downcase_pronouns = {
        'E' => 'e',
        'A' => 'a',
        'O' => 'o',
        'De' => 'de',
        'Do' => 'do',
        'Da' => 'da'
      }
      str.gsub(/ (#{downcase_pronouns.keys.join('|')}) /) { |_s| " #{downcase_pronouns[_s.strip]} " }
    end
    subcategories = Detail.where(translation_token: 'categoria').group(:description).pluck(:description).map do |s|
      downcase_pronouns_this(s.titleize)
    end.flatten.uniq

    categories = Product.joins(:details).
      select("products.category, details.description").
      where("details.translation_token = ?", 'categoria').
      group('products.category, details.description').
      all.inject({}) do |k,v|
      c = Category.t(v['category'].to_i).titleize
      k[c] ||= []
      k[c].push(downcase_pronouns_this(v['description'].titleize)).uniq!
      k[c].compact!
      k
    end

    brands = Product.all.map(&:brand).compact.map do |b|
      downcase_pronouns_this(b.titleize)
    end.flatten.uniq

    colors = Detail.where(translation_token: 'cor filtro').group(:description).pluck(:description).map do |c|
      downcase_pronouns_this(c.titleize)
    end

    File.open( File.expand_path( File.join( File.dirname(__FILE__), '../../config/seo_url_colors.yml')), 'w') do |f|
      f.puts YAML.dump(colors)
    end

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
