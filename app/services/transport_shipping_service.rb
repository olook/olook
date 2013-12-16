class TransportShippingService
  DEFAULT_DELIVERY_TIME_FACTOR = 0.2
  DEFAULT_PRICE_FACTOR = 0.3
  attr_reader :transport_shippins
  attr_accessor :return_shippings

  def initialize transport_shippins
    @transport_shippins = transport_shippins
    @return_shippings = []
  end

  def choose_better_transport_shipping
    return transport_shippins if transport_shippins.count == 1
    sort_shipping_services = order_by_cost
    better_shipping = sort_shipping_services.delete_at(0)
    return_shippings << better_shipping
    sort_shipping_services.each do |shipping|
      return_shippings << shipping if delivery_time_calculation(shipping[:delivery_time],better_shipping[:delivery_time]) && price_calculation(shipping[:price],better_shipping[:price])
    end
    return_shippings.first(2)
  end

  private
    def order_by_cost
      transport_shippins.sort{|x,y| x[:cost] <=> y[:cost]}
    end
    def delivery_time_calculation delivery_time, control_delivery_time
      delivery_time <= (control_delivery_time - (control_delivery_time * DEFAULT_DELIVERY_TIME_FACTOR))
    end
    def price_calculation price, price_control
      price >= (price_control + (price_control * DEFAULT_PRICE_FACTOR))
    end
end
