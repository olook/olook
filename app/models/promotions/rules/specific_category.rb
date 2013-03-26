# -*- encoding : utf-8 -*-
class SpecificCategory < PromotionRule

  def matches?(cart, parameter=nil)
    return false if cart.items.empty? || parameter.nil?
    categories = cart.items.collect(&:product).collect(&:category_humanize).map {|c| c.downcase }
    categories.include?(parameter.downcase)
  end
end

