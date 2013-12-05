# encoding: utf-8
class Freebie
  def initialize(attrs={})
    @subtotal = attrs[:subtotal]
  end

  def can_receive_freebie?
    @subtotal.to_f > 200
  end

  def what_can_i_do_to_receive_freebie
    miss = 200.0 - @subtotal.to_f
    "Falta R$ #{miss.to_i},#{( (miss - miss.to_i) * 100 ).round} para conseguir o brinde"
  end

  class << self
    def product_is_freebie?(product_id)
      product_id.to_i == 23035
    end
  end
end
