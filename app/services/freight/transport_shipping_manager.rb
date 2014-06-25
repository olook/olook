class Freight::TransportShippingManager

    DEFAULT_FREIGHT = {
    default_shipping: {
      price: FreightCalculator::DEFAULT_FREIGHT_PRICE,
      cost: FreightCalculator::DEFAULT_FREIGHT_COST,
      delivery_time: FreightCalculator::DEFAULT_INVENTORY_TIME_WITH_EXTRA_TIME,
      shipping_service_id: FreightCalculator::DEFAULT_FREIGHT_SERVICE
    }
  }

  def initialize(zip_code,amount_value, transport_shippings)
    @zip_code = zip_code
    @amount_value = amount_value
    @transport_shippings = transport_shippings
  end

  def default
    return DEFAULT_FREIGHT if @transport_shippings.empty?
    return parse_info(@transport_shippings.first) if @transport_shippings.size == 1
    chosen = choose_by_cost
    chosen = check_free_freight_policy(chosen)
    parse_info(chosen)
  end

  def fast
  end

  private
  def parse_info shipping
    {price: shipping.income || FreightCalculator::DEFAULT_FREIGHT_PRICE,
                     cost: shipping.cost || FreightCalculator::DEFAULT_FREIGHT_COST,
                     delivery_time: shipping.delivery_time.to_i + FreightCalculator::DEFAULT_INVENTORY_TIME,
                     shipping_service_id: shipping.shipping_service_id || FreightCalculator::DEFAULT_FREIGHT_SERVICE
    }
  end

  def choose_by_cost
    @transport_shippings.sort {|x,y| x.cost <=> y.cost }.first
  end

  def check_free_freight_policy(chosen)
    if Freight::FreeCostPolicy.apply?( ShippingPolicy.with_zip(@zip_code), @amount_value)
      chosen[:default_shipping][:price] = '0.0'.to_d
    end
    chosen
  end
end
