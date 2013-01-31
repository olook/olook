#batches of 1000
Order.find_each do |o|
  if o.expected_delivery_on.nil? || o.shipping_service_name.nil?
	updated_at = o.updated_at
    o.update_attribute(:expected_delivery_on, o.freight.delivery_time.days.from_now) if o.freight && o.freight.delivery_time
    o.update_attribute(:shipping_service_name, o.freight.shipping_service.name) if o.freight && o.freight.shipping_service
    o.update_attribute(:updated_at, updated_at)
    puts "updated #{o.inspect}"
 end
end