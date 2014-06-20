# -*- encoding : utf-8 -*-
class SpecificSubcategoryCount < PromotionRule

  def name
    'Colocar na sacola itens dos modelos com quantidade total de produtos ex.: (3) blusa,vestido...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter=nil)
    return false unless cart
    return false if cart.items.empty? || parameter.nil?
    /\A\((?<total_count>\d+)\) (?<subcategories>.*)\z/ =~ parameter.to_s
    subcategories = Set.new(subcategories.split(/\s*,\s*/).map { |s| s.parameterize })
    cart_subcategories = cart.items.map {|i| [i.product.subcategory.parameterize] * i.quantity }.flatten.select{ |c| subcategories.include?(c) }
    cart_subcategories.size >= total_count.to_i
  end
end

