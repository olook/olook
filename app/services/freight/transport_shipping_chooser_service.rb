class Freight::TransportShippingChooserService
  def initialize(shippings)
    @shippings = shippings
  end

  def perform
    return formated_hash(@shippings.first,'default_shipping') if @shippings.size == 1
    cheaper_shipping = choose_by_cost
    express_shipping = choose_by_delivery_time(cheaper_shipping)
    cheaper_shipping.merge(express_shipping)
  end

  private
  def formated_hash(shipping,type)
    {type.to_sym => {price: shipping.income || FreightCalculator::DEFAULT_FREIGHT_PRICE,
                     cost: shipping.cost || FreightCalculator::DEFAULT_FREIGHT_COST,
                     delivery_time: shipping.delivery_time.to_i + FreightCalculator::DEFAULT_INVENTORY_TIME,
                     shipping_service_id: shipping.shipping_service_id || FreightCalculator::DEFAULT_FREIGHT_SERVICE
    }}
  end

  def choose_by_cost
    chosen = @shippings.sort {|x,y| x.cost <=> y.cost }.first
    formated_hash(chosen, 'default_shipping')
  end

  def choose_by_delivery_time(cheaper_shipping)
    faster = @shippings.select{|ship| (ship.delivery_time+FreightCalculator::DEFAULT_INVENTORY_TIME) < cheaper_shipping[:default_shipping][:delivery_time] && ship.shipping_service_id != cheaper_shipping[:default_shipping][:shipping_service_id]}.sort {|x,y| x.delivery_time <=> y.delivery_time }.first
    return {} if faster.blank?
    formated_hash(faster, 'fast_shipping')
  end
end
