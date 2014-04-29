class ShippingImporterService


  def initialize(filename, parser)
    @filename = filename
    @parser = parser
  end

  def process_file
    import_csv
  end

  private

  def import_csv
    csv_array = load_csv
    @parser.prepare csv_array
    @parser.delete_query
    save_all csv_array
  end

  def save_all csv_array
    query_entries = @parser.transform_array_into_query_entries(csv_array)
    values = query_entries.shift(1000)

    while values.size > 0 do
      ActiveRecord::Base.connection.insert(@parser.insert_prefix + values.join(','))
      values = query_entries.shift(1000)
    end
  end

  def load_csv
    temp_file_uploader = TempFileUploader.new
    temp_file_uploader.retrieve_from_store! @filename
    temp_file_uploader.cache_stored_file!
    CSV.read(temp_file_uploader.file.path, {:col_sep => ';'})[1 .. -1]
  end

end
