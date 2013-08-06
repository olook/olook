# -*- encoding : utf-8 -*-
class AssociateProductWithCollectionThemeService
  attr_accessor :response_keys, :product_ids

  def initialize(filecontent)
    @lines = filecontent.split(/[\n\r]/).map{ |r| r.strip}
    header_row = @lines.shift
    header = header_row.split("\t")
    @product_index = header.index('CodigoProduto')
    @categorias_site_index = header.index('CategoriasSite')
    @input = {}
    @lines.each do |l|
      line = l.split("\t")
      @input[line.at(@product_index)] = line.at(@categorias_site_index).to_s.split(/\D/)
    end
  end

  def process!
    @input.each do |product_id, collection_theme_ids|
      product = products[product_id.to_i]
      next unless product
      cts = collection_theme_ids.map { |id| collection_themes[id.to_i] }.compact
      product.collection_themes = (cts.to_a | product.collection_themes.to_a)
    end
  end

  def products
    @products ||= Product.where(id: @input.keys.uniq).all.inject({}) do |h, item|
      h[item.id] = item
      h
    end
  end

  def collection_themes
    @collection_themes ||= CollectionTheme.where(id: @input.values.flatten.uniq).all.inject({}) do |h, item|
      h[item.id] = item
      h
    end
  end
end
