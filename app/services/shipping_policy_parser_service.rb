class ShippingPolicyParserService

  def prepare csv_array
  end

  def insert_prefix
    "INSERT INTO `#{ShippingPolicy.table_name}` (`created_at`, `updated_at`, `zip_start`, `zip_end`, `free_shipping`) VALUES "
  end

  def delete_query
    ActiveRecord::Base.connection.delete "DELETE FROM `#{ShippingPolicy.table_name}`"
  end

  def transform_array_into_query_entries csv_array
    now = Time.zone.now.utc.iso8601.gsub(/T/, ' ').gsub('Z', '')
    response = csv_array.each.map do |row|
      value = free_shipping_starting_value(row)
      next if value == 0.0
      ( "('%s', '%s', '%s', '%s', '%s' )" % [now, now, row[2],row[3], value] ) rescue nil
    end
    response.compact
  end

  def find_shipping_service name
    shipping_service_name = name.upcase
    ShippingService.find_or_create_by_name(shipping_service_name)
  end

  def free_shipping_starting_value row
    return 1.0 if NumericParser.parse_float(row[4]) == 0.0
    return 200.0 if NumericParser.parse_float(row[5]) == 0.0
    return 250.0 if NumericParser.parse_float(row[6]) == 0.0
    return 300.0 if NumericParser.parse_float(row[7]) == 0.0
    0.0
  end

end
