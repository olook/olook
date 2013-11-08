# -*- encoding : utf-8 -*-
class SpecificCategory < PromotionRule

  def eg
    "Somente ao adicionar um produto de certa categoria o desconto é ativado"
  end

  def label_text
    "Categoria do produto"
  end

  def matches?(cart, parameter=nil)
    return false if cart.items.empty? || parameter.nil?
    categories = cart.items.collect(&:product).collect(&:category_humanize).map {|c| c.parameterize }
    categories.include?(parameter.parameterize)
  end
end

