# -*- encoding : utf-8 -*-
class BeachWearCategory < PromotionRule

  def name
    'Quantidade de items Moda Praia deve ser maior que...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter=nil)
    return false if cart.items.empty? || parameter.nil?
    
    amount = cart.items.select{|i| i.product.category == Category::BEACHWEAR}
      .inject(0) { |amount, i| amount += i.quantity }

    amount >= parameter.to_i 
  end
end