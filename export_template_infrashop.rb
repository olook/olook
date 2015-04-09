ActiveRecord::Base.logger = Logger.new STDOUT
include ProductsHelper

header1 = ['RB Master Product Tree', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'Atributos', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SKU', '', '', '', '', '', '', '', '', '']
header = ['',
          'ID SKU',
          'Product ID',
          'Categoria',
          'N Mexer',
          'N Mexer',
          'N Mexer',
          'Nome Produto',
          'Nome Curto',
          'Descrição',
          'Tipo de Produto',
          'Mostra Indisponivel*',
          'Título',
          'Meta Description',
          'Meta Keywords',
          'Cor',
          'Tamanho',
          'Marca',
          'Marcar A-Z',
          'Modelo',
          'Material',
          'Material da Sola',
          'Material Interno',
          'Comprimento',
          'Sutiã (larg)',
          'Sutiã (alt)',
          'Largura',
          'Largura bojo',
          'Altura bojo',
          'Altura Cano',
          'Altura',
          'Altura com alça',
          'Profundidade',
          'Circunferência',
          'Busto',
          'Quadril',
          'Ombro',
          'Cós',
          'Gancho',
          'Manga',
          'Coxa',
          'Panturrilha',
          'Braço',
          'Medidas',
          'Dicas',
          'Salto',
          'Conforto & Proteção',
          'Ocasiões',
          'Tendências',
          'Perfil',
          'Presentes',
          'Especiais',
          'Editoriais',
          'google_product_category',
          'Referência',
          'Nome do Sku',
          'Tipo',
          'Altura (metro)*',
          'Largura (metro)*',
          'Comprimento (metro)*',
          'Peso (kilo)*',
          'Tipo de transportadora*',
          'Modelo do produto no fabricante',
          'Código SKU fornecedor principal',
          'EAN']
CSV.open('template_infrashop.csv', 'wb') do |csv|
  csv << header1
  csv << header
  Variant.includes(:product).order(:product_id).find_each(batch_size: 1000) do |variant|
    begin
    product = variant.product
    row = ['']
    row.push(variant.number) # 'ID SKU'
    row.push(product.model_number) # 'Product ID'
    row.push("Home>#{product.category_humanize}>#{product.subcategory}>#{product.formatted_name(30)}") # 'Categoria'
    row.push('') # 'N Mexer'
    row.push('') # 'N Mexer'
    row.push('') # 'N Mexer'
    row.push(product.formatted_name(200)) # 'Nome Produto'
    row.push(product.name) # 'Nome Curto'
    row.push(product.description_html) # 'Descrição'
    row.push('Normal') # 'Tipo de Produto'
    row.push('Sim') # 'Mostra Indisponivel*'
    row.push(product.title_text) # 'Título'
    row.push(product.description) # 'Meta Description'
    row.push("") # 'Meta Keywords'
    row.push(product.color_name) # 'Cor'
    row.push(variant.description) # 'Tamanho'
    row.push(product.brand) # 'Marca'
    row.push("") # 'Marca A-Z'
    row.push(product.subcategory) # 'Modelo'

    material = product.details.find{|d| d.translation_token == "material" }.try(:description)
    row.push(material) # 'Material'
    row.push(product.details.find{|d| d.translation_token == "Material da Sola" }.try(:description)) # 'Material da Sola'
    row.push(product.details.find{|d| d.translation_token == "Material Interno" }.try(:description)) # 'Material Interno'

    product_detail_info = product.details.only_specification.without_specific_translations.with_valid_values.where(translation_token: 'Detalhes').first
    medidas = {}
    if /^(?<modelo_veste>[0-9a-z]*)#(?<sizes>.*)/mi =~ product_detail_info.to_s && /=>/mi =~ product_detail_info.to_s
      sizes_split = sizes.split(';').find { |s| /^#{variant.description}=>/ =~ s.to_s }
      if sizes_split.nil?
        sizes_split = sizes.to_s
      end
      size, details = sizes_split.split(/=>/)
      medidas = details.split(',').inject({}) do |h, detail|
        k,v = detail.split(':')
        h[k.strip.parameterize] = v.strip
        h
      end
    elsif /^Modelo Veste: (?<modelo_veste>[^;]+);(?<sizes>.*)/mi =~ product_detail_info.to_s
      sizes_split = sizes.split(';').find { |s| /^#{variant.description}:/ =~ s.to_s }
      if sizes_split.nil?
        sizes_split = sizes.to_s
      end
      size, details = sizes_split.split(/: */)
      medidas = details.split(/ ?\/ ?/).inject({}) do |h, detail|
        k,v = detail.split(/ ?Ø? /)
        h[k.strip.parameterize] = v.strip
        h
      end
    elsif /;/mi =~ product_detail_info.to_s
      sizes = product_detail_info.to_s
      sizes_split = sizes.split(';').find { |s| /^#{variant.description}:/ =~ s.to_s }
      if sizes_split.nil?
        sizes_split = sizes.to_s
      end
      medidas = sizes_split.split(/ ?\/ ?/).inject({}) do |h, detail|
        k,v = detail.split(/:/)
        h[k.strip.parameterize] = v.strip
        h
      end
    end


    row.push(medidas['comprimento'] || medidas['comp'] || "") # Comprimento
    row.push(medidas['largura'] || "") # Sutiã (larg)
    row.push(medidas['altura'] || "") # Sutiã (alt)
    row.push(medidas['largura'] || "") # Largura
    row.push(medidas['largura-bojo'] || "") # Largura bojo
    row.push(medidas['altura-bojo'] || "") # Altura bojo
    row.push(medidas['altura-canp'] ||"") # Altura Cano
    row.push(medidas['altura'] ||"") # Altura
    row.push(medidas['altura-com-alca'] ||"") # Altura com alça
    row.push(medidas['profundidade'] ||"") # Profundidade
    row.push(medidas['circunferencia'] ||"") # Circunferência
    row.push(medidas['busto'] ||"") # Busto
    row.push(medidas['quadril'] ||"") # Quadril
    row.push(medidas['ombro'] ||"") # Ombro
    row.push(medidas['cos'] ||"") # Cós
    row.push(medidas['gancho'] ||"") # Gancho
    row.push(medidas['manga'] ||"") # Manga
    row.push(medidas['coxa'] ||"") # Coxa
    row.push(medidas['panturrilha'] ||"") # Panturrilha
    row.push(medidas['braco'] ||"") # Braço
    row.push(medidas['cano'] ||"") # Cano

    product_detail_info = product.details.only_specification.without_specific_translations.with_valid_values.where(translation_token: 'Detalhes').first
    row.push(product_detail_info.try(:description)) # 'Medidas'
    row.push(product.tips) # 'Dicas'
    row.push(product.heel) # 'Salto'
    care = Product::CARE_PRODUCTS.include?(product.subcategory)
    row.push(care ? product.subcategory : "") # 'Conforto & Proteção'

    collection_themes = product.collection_themes.all
    groups = collection_themes.map { |c| c.collection_theme_group.name.downcase rescue '' }
    cols = ->(downgroup) { collection_themes.select { |c| c.collection_theme_group.try(:name).to_s.downcase == downgroup }.map { |c| c.name }.compact.flatten.join('|') }
    row.push(groups.include?('ocasiões') ? cols.call('ocasiões') : "") # 'Ocasiões'
    row.push(groups.include?('tendências') ? cols.call('tendências') : "") # 'Tendências'
    row.push(product.profiles.map { |pp| pp.name }.join('|')) # Perfil
    row.push(groups.include?('presentes') ? cols.call('presentes') : "") # 'Presentes'
    row.push(groups.include?('especiais') ? cols.call('especiais') : "") # 'Especiais'
    row.push(groups.include?('editoriais') ? cols.call('editoriais') : ""'') # 'Editoriais'
    row.push('') # 'google_product_category'
    row.push(variant.number) # 'Referência'
    row.push(product.name) # 'Nome do Sku'
    row.push('Normal') # 'Tipo'
    row.push(variant.height) # 'Altura (metro)*'
    row.push(variant.width) # 'Largura (metro)*'
    row.push(variant.length) # 'Comprimento (metro)*'
    row.push(variant.weight) # 'Peso (kilo)*'
    row.push('') # 'Tipo de transportadora*'
    row.push('') # 'Modelo do produto no fabricante'
    row.push('') # 'Código SKU fornecedor principal'
    row.push('') # 'EAN'
    csv << row
    rescue => e
      STDOUT.puts "#{e.class} #{e.message}: #{e.backtrace.first}"
      raise e
    end
  end
end


