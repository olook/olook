#batches of 1000
Freight.find_each do |f|
  if o = f.order
    if o.expected_delivery_on.nil? || o.shipping_service_name.nil? || o.freight_state.nil?
      updated_at = o.updated_at

      o.update_attribute(:expected_delivery_on, f.delivery_time.days.from_now) if f.delivery_time
      o.update_attribute(:shipping_service_name, f.shipping_service.name) if f.shipping_service
      o.update_attribute(:freight_state, f.state) if f.state

      o.update_attribute(:updated_at, updated_at)

      puts "freight state: #{f.state}"
      puts "order freight_state: #{o.freight_state}"
    end
  else
	puts ""
	puts "no order for this freight #{f.inspect}"
	puts ""
  end
end
