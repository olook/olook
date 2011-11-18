# -*- encoding : utf-8 -*-
class ImportFreightPricesWorker
  @queue = :import_freight

  def self.perform(shipping_service_id, temp_filename)
    shipping_service = ShippingService.find shipping_service_id
    
    shipping_service.freight_prices.destroy_all

    count = -1
    load_data(temp_filename).each do |line|
      # Ignore first line of the file, which should contain header text
      next if (count += 1) == 0

      data = line.map {|column| column.force_encoding 'utf-8' }

      create_freight(shipping_service, data)
    end
  end

protected  

  def self.load_data(temp_filename)
    temp_file_uploader = TempFileUploader.new
    temp_file_uploader.retrieve_from_store!(temp_filename)
    temp_file_uploader.cache_stored_file!

    CSV.read(temp_file_uploader.file.path)
  end
  
  def self.create_freight(shipping_service, data)
    shipping_service.freight_prices.build.tap do |freight|
      freight.zip_start = data[1]
      freight.zip_end = data[2]
      freight.weight_start = data[5].to_f
      freight.weight_end = data[6].to_f
      freight.delivery_time = data[7]
      freight.price = data[8].to_f
      freight.cost = data[9].to_f

      freight.description = "#{data[0]} - #{data[3]} - #{data[4]} - #{data[10]} - #{data[11]}"
      
      freight.save
    end
  end
end
