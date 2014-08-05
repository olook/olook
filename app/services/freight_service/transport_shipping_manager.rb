class FreightService::TransportShippingManager
  MOTOBOY_SERVICE = ShippingService.find_by_erp_code('LOGGI')
  def default_shipping
    Struct.new('DefaultShipping', :income, :cost, :delivery_time, :shipping_service_id).new(
      @freight_calculator::DEFAULT_FREIGHT_PRICE,
      @freight_calculator::DEFAULT_FREIGHT_COST,
      @freight_calculator::DEFAULT_INVENTORY_TIME_WITH_EXTRA_TIME,
      @freight_calculator::DEFAULT_FREIGHT_SERVICE
    )
  end

  def initialize(zip_code, amount_value, transport_shippings, opts={})
    @zip_code = zip_code
    @amount_value = amount_value
    @freight_calculator = opts[:freight_calculator] || FreightCalculator
    @transport_shippings = transport_shippings.to_a.empty? ? [default_shipping] : transport_shippings
  end

  def default
    return @default if @default
    policies = find_policies_for_zip
    @default = choose_by_cost
    @default = check_free_freight_policy(@default,policies)
    @default[:kind] = 'default'
    @default[:free_shipping_value] = policies.try(:first).try(:free_shipping)
    @default
  end

  def fast
    return @fast if @fast
    @fast = choose_by_delivery_time
    @fast = nil if @fast && @fast[:delivery_time] >= default[:delivery_time]
    @fast = nil if @fast && @fast[:price] <= default[:price]
    if @fast
      @fast[:kind] = "fast"
      if MOTOBOY_SERVICE.try(:id) == @fast[:shipping_service_id] && Setting.superfast_shipping_enabled && work_time?
        @fast[:kind] = "motoboy"
        @fast[:delivery_time] = 0.125
      end
    end
    @fast
  end

  def to_json
    [ default, fast ].compact
  end

  def api_hash
    [ default, fast ].compact.map do |ts|
      ts.delete(:cost)
      ts
    end
  end

  private

  def work_time?
    current_time = Time.zone.now
    Time.workday?(current_time) && !Time.before_business_hours?(current_time) && !Time.after_business_hours?(current_time)
  end

  def parse_info shipping
    {
      price: shipping.income || @freight_calculator::DEFAULT_FREIGHT_PRICE,
      cost: shipping.cost || @freight_calculator::DEFAULT_FREIGHT_COST,
      delivery_time: shipping.delivery_time.to_i + @freight_calculator::DEFAULT_INVENTORY_TIME,
      shipping_service_id: shipping.shipping_service_id || @freight_calculator::DEFAULT_FREIGHT_SERVICE
    }
  end

  def choose_by_delivery_time
    @transport_shippings.map { |s| parse_info(s) }.sort {|a,b| a[:delivery_time] <=> b[:delivery_time] }.first
  end

  def choose_by_cost
    @transport_shippings.map { |s| parse_info(s) }.sort {|a,b| a[:cost] <=> b[:cost] }.first
  end

  def is_free_cost?(policies)
    Freight::FreeCostPolicy.apply?(policies, @amount_value)
  end

  def check_free_freight_policy(chosen,policies)
    if is_free_cost?(policies)
      chosen[:price] = '0.0'.to_d
    end
    chosen
  end

  def find_policies_for_zip
    ShippingPolicy.with_zip(@zip_code)
  end
end
