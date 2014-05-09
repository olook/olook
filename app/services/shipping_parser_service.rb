class ShippingParserService

  def prepare csv_array
    @shipping_service = find_shipping_service(csv_array.first[0])    
  end

  def insert_prefix
    "INSERT INTO `#{Shipping.table_name}` (`created_at`, `updated_at`, `zip_start`, `zip_end`, `delivery_time`, `income`, `cost`, `shipping_service_id`) VALUES "
  end

  def delete_query
    ActiveRecord::Base.connection.delete "DELETE FROM `#{Shipping.table_name}` WHERE shipping_service_id = #{@shipping_service.id}" unless @shipping_service.blank?
  end

  def transform_array_into_query_entries csv_array
    now = Time.zone.now.utc.iso8601.gsub(/T/, ' ').gsub('Z', '')
    csv_array.each.map do |row| 
      ( "('%s', '%s', '%s', '%s', %d, %0.2f, %0.2f, %d )" % [now, now, row[1],row[2],row[5], NumericParser.parse_float(row[6]),NumericParser.parse_float(row[7]), @shipping_service.id] ) rescue nil
    end
  end

  def find_shipping_service name
    shipping_service_name = name.upcase
    ShippingService.find_or_create_by_name(shipping_service_name)
  end

end