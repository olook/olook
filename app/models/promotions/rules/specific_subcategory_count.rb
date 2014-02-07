# -*- encoding : utf-8 -*-
class SpecificSubcategoryCount < PromotionRule

  def name
    'Colocar na sacola itens dos modelos com quantidade total de produtos ex.: (3) blusa,vestido...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter=nil)
    return false if cart.items.empty? || parameter.nil?
    cart_subcategories = Set.new(cart.items.collect(&:product).collect(&:subcategory).map {|c| c.parameterize })
    /\A\((?<total_count>\d+)\) (?<subcategories>.*)\z/ =~ parameter.to_s
    subcategories = subcategories.split(/\s*,\s*/).map { |s| s.parameterize }
    subcategories.all? do |subcategory|
      cart_subcategories.include?(subcategory)
    end
  end
end

