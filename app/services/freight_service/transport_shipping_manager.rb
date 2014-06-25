class FreightService::TransportShippingManager
  def default_freight
    {
      default_shipping: {
        price: @freight_calculator::DEFAULT_FREIGHT_PRICE,
        cost: @freight_calculator::DEFAULT_FREIGHT_COST,
        delivery_time: @freight_calculator::DEFAULT_INVENTORY_TIME_WITH_EXTRA_TIME,
        shipping_service_id: @freight_calculator::DEFAULT_FREIGHT_SERVICE
      }
    }
  end

  def initialize(zip_code, amount_value, transport_shippings, opts={})
    @zip_code = zip_code
    @amount_value = amount_value
    @transport_shippings = transport_shippings
    @freight_calculator = opts[:freight_calculator] || FreightCalculator
  end

  def default
    return default_freight if @transport_shippings.empty?
    return parse_info(@transport_shippings.first) if @transport_shippings.size == 1
    chosen = choose_by_cost
    chosen = check_free_freight_policy(chosen)
    parse_info(chosen)
  end

  def fast
  end

  def to_json
    {
      default_shipping: default,
      fast_shipping: fast
    }
  end

  private
  def parse_info shipping
    {
      price: shipping.income || @freight_calculator::DEFAULT_FREIGHT_PRICE,
      cost: shipping.cost || @freight_calculator::DEFAULT_FREIGHT_COST,
      delivery_time: shipping.delivery_time.to_i + @freight_calculator::DEFAULT_INVENTORY_TIME,
      shipping_service_id: shipping.shipping_service_id || @freight_calculator::DEFAULT_FREIGHT_SERVICE
    }
  end

  def choose_by_cost
    @transport_shippings.sort {|x,y| x.cost <=> y.cost }.first
  end

  def is_free_cost?
    Freight::FreeCostPolicy.apply?( ShippingPolicy.with_zip(@zip_code), @amount_value)
  end

  def check_free_freight_policy(chosen)
    if is_free_cost?
      chosen[:default_shipping][:price] = '0.0'.to_d
    end
    chosen
  end
end
