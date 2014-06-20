# -*- encoding : utf-8 -*-
class SpecificCollectionThemeCount < PromotionRule
  def name
    'Colocar na sacola itens das coleções com quantidade total de produtos ex.: (3) casual,trabalho...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter=nil)
    return false unless cart
    return false if cart.items.empty? || parameter.nil?
    /\A\((?<total_count>\d+)\) (?<collection_themes>.*)\z/ =~ parameter.to_s
    collection_themes = collection_themes.split(/\s*,\s*/).map { |c| c.parameterize }
    itens_in_collections = cart.items.inject(0) do |sum, i|
      if ( i.product.collection_themes.map {|c| c.slug.parameterize } & collection_themes ).size > 0
        sum + ( 1 * i.quantity )
      else
        sum
      end
    end
    itens_in_collections >= total_count.to_i
  end
end

