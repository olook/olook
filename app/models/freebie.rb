# encoding: utf-8
class Freebie
  def initialize(attrs={})
    @subtotal = attrs[:subtotal]
    @cart_id = attrs[:cart_id]
    if can_receive_freebie?
      key = "iwantfreebie/#{@cart_id}"
      v = REDIS.get(key)
      Freebie.save_selection_for(@cart_id, '1') if v.nil?
    end
  end

  def can_receive_freebie?
    @subtotal.to_f > 200
  end

  def what_can_i_do_to_receive_freebie
    miss = 200.0 - @subtotal.to_f
    "Falta R$ #{miss.to_i},#{( (miss - miss.to_i) * 100 ).round} para conseguir o brinde"
  end

  def variant_id
    55593
  end

  class << self
    def product_is_freebie?(product_id)
      product_id.to_i == 23035
    end

    def save_selection_for(cart_id, val)
      key = "iwantfreebie/#{cart_id}"
      REDIS.setex(key, 1.hour, val)
    end

    def selection_for(cart_id)
      key = "iwantfreebie/#{cart_id}"
      v = REDIS.get(key)
      v.to_s == '1'
    end
  end
end
