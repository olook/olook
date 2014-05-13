class PictureProcess::ProductPictures
  @queue = 'low'
  class ProductNotFound < StandardError; end
  def self.perform(key, pictures)
    log_time("Initializing PictureProcess for product #{key} with #{pictures.size} pictures") do
    product = Product.find_by_id key

    save_product_image(product, pictures, /still/i, 'picture_for_xml')
    save_product_image(product, pictures, /sample/i, 'color_sample')
    product.save
    save_pictures(product, pictures)
    end
  end

  def self.save_pictures(product, pictures)
    product.pictures.destroy_all if product.pictures.count > 1
    _pics = pictures.select { |image| %r{/[\d-]+\.jpe?g$}i =~ image }.sort
    _pics.each_with_index do |image, index|
      picture = Picture.new(product: product, display_on: index + 1)
      retry_block(5) do
        picture.remote_image_url = image
      end
      picture.save
    end
  end

  def self.save_product_image(product, pictures, pattern, field)
    image = pictures.find { |img| pattern =~ img }
    retry_block(5) do
      product.send("remote_#{field}_url=", image) if image
    end
  end

  def self.logger
    @@logger ||= Logger.new(PictureProcess::LOGGER_FILE)
  end

  def self.log_time(message)
    time_start = Time.zone.now
    logger.debug(message)
    yield
    logger.debug('Finished in %.2fs' % ( Time.zone.now - time_start ) )
  end

  def self.retry_block(times)
    count = 0
    begin
      yield
    rescue Exception => e
      if count > times
        raise e
      else
        count += 1
        retry
      end
    end
  end
end
