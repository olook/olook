# -*- encoding : utf-8 -*-
class SpecificCategory < PromotionRule

  def name
    'Colocar na sacola itens das categorias...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter=nil)
    return false if cart.items.empty? || parameter.nil?
    categories = cart.items.collect(&:product).collect(&:category_humanize).map {|c| c.parameterize }
    categories.include?(parameter.parameterize)
  end
end

