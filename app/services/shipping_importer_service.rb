class ShippingImporterService

  def initialize filename
    @filename = filename
  end

  def process_file
    import_csv
  end

  private

  def import_csv
    csv_array = load_csv
    @shipping_service = find_shipping_service(csv_array.first[0])
    delete_previous_shippings
    save_all csv_array
  end

  def save_all csv_array
    query_entries = transform_array_into_query_entries(csv_array)
    values = query_entries.shift(1000)

    while values.size > 0 do
      Shipping.connection.insert(insert_query_prefix + values.join(','))
      values = query_entries.shift(1000)
    end
  end

  def insert_query_prefix
    "INSERT INTO `#{Shipping.table_name}` (`created_at`, `updated_at`, `zip_start`, `zip_end`, `delivery_time`, `income`, `cost`, `shipping_service_id`) VALUES "
  end

  def transform_array_into_query_entries csv_array
    now = Time.zone.now.utc.iso8601.gsub(/T/, ' ').gsub('Z', '')
    csv_array.each.map do |row| 
      ( "('%s', '%s', '%s', '%s', %d, %0.2f, %0.2f, %d )" % [now, now, row[1],row[2],row[5], parse_float(row[6]),parse_float(row[7]), @shipping_service.id] ) rescue nil
    end
  end

  def delete_previous_shippings
    Shipping.connection.delete("DELETE FROM `#{Shipping.table_name}` WHERE shipping_service_id = #{@shipping_service.id}")
  end

  def find_shipping_service name
    shipping_service_name = name.upcase
    ShippingService.find_or_create_by_name(shipping_service_name)
  end

  def load_csv
    temp_file_uploader = TempFileUploader.new
    temp_file_uploader.retrieve_from_store! @filename
    temp_file_uploader.cache_stored_file!
    CSV.read(temp_file_uploader.file.path, {:col_sep => ';'})[1 .. -1]
  end

  def parse_float float_value
    BigDecimal.new(float_value.gsub(/[^\d,\.]/, '').gsub(',','.'), 10)
  end  
end
