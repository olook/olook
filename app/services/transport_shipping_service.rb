class TransportShippingService
  DEFAULT_DELIVERY_TIME_FACTOR = 0.2
  DEFAULT_PRICE_FACTOR = 0.3
  attr_reader :transport_shippings
  attr_accessor :return_shippings

  def initialize transport_shippings
    @transport_shippings = transport_shippings
    @return_shippings = {}
  end

  def choose_better_transport_shipping
    default_shipping = better_cost_shipping
    fast_shipping = better_time_shipping

    return_shippings[:default_shipping] = default_shipping
    
    fast_delivery_time, fast_price = fast_shipping[:delivery_time], fast_shipping[:price]
    default_delivery_time, default_price = default_shipping[:delivery_time], default_shipping[:price]

    set_fast_shipping(fast_shipping) if has_smaller_deliver_time?(fast_delivery_time, default_delivery_time) && has_major_price?(fast_price, default_price)

    return_shippings
  end

  private
    def better_cost_shipping
      transport_shippings.sort{|x,y| x[:cost] <=> y[:cost]}.first
    end
    def better_time_shipping
      transport_shippings.sort{|x,y| x[:delivery_time] <=> y[:delivery_time]}.first
    end
    def set_fast_shipping shipping
      return_shippings[:fast_shipping] = shipping if return_shippings[:default_shipping] != shipping
    end

    #Criar classes para fazer isso
    def has_smaller_deliver_time? delivery_time, control_delivery_time
      delivery_time <= (control_delivery_time - (control_delivery_time * DEFAULT_DELIVERY_TIME_FACTOR))
    end
    def has_major_price? price, price_control
      price > (price_control + (price_control * DEFAULT_PRICE_FACTOR))
    end
end
