class Freight::TransportShippingChooserService
  def initialize(shippings)
    @shippings = shippings
    @return_hash = {}
  end

  def perform
    return formated_hash(@shippings.first) if @shippings.size == 1
    @return_hash.merge!(formated_hash(better_cost_shipping))
    search_fast_shipping
    @return_hash
  end

  private
  def formated_hash(shipping,type='default_shipping')
    {type.to_sym => {price: shipping.income || FreightCalculator::DEFAULT_FREIGHT_PRICE,
                     cost: shipping.cost || FreightCalculator::DEFAULT_FREIGHT_COST,
                     delivery_time: shipping.delivery_time || FreightCalculator::DEFAULT_INVENTORY_TIME,
                     shipping_service_id: shipping.shipping_service_id || FreightCalculator::DEFAULT_FREIGHT_SERVICE
    }}
  end

  def better_cost_shipping
    @shippings.sort {|x,y| x.cost <=> y.cost }.first
  end

  def search_fast_shipping
    @shippings.delete_if{|ship| ship.shipping_service_id == @return_hash[:default_shipping][:shipping_service_id]}
    fast = @shippings.select{|ship| ship.delivery_time < @return_hash[:default_shipping][:delivery_time]}.first
    @return_hash.merge!(formated_hash(fast,'fast_shipping')) unless fast.blank?
  end
end
