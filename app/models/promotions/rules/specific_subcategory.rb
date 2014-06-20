# -*- encoding : utf-8 -*-
class SpecificSubcategory < PromotionRule

  def name
    'Colocar na sacola itens dos modelos...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter=nil)
    return false unless cart
    return false if cart.items.empty? || parameter.nil?
    categories = cart.items.collect(&:product).collect(&:subcategory).map {|c| c.parameterize }
    categories.include?(parameter.parameterize)
  end
end

