class PictureProcess::ProductPictures
  @queue = 'normal'
  class ProductNotFound < StandardError; end
  def self.perform(key, pictures)
    time_start = Time.zone.now
    logger.debug("Initializing PictureProcess for product #{key} with #{pictures.size} pictures")
    product = Product.find_by_id key

    product.pictures.destroy_all if product.pictures.count > 1
    sample = pictures.find { |image| /sample/i =~ image }
    if sample
      product.remote_color_sample_url = sample
      product.save
    end
    _pics = pictures.select { |image| %r{/[\d-]+\.jpg$}i =~ image }.sort
    _pics.each_with_index do |image, index|
      picture = Picture.new(product: product, display_on: index + 1)
      picture.remote_image_url = image
      picture.save
    end
    logger.debug('Finished in %.2fs' % ( Time.zone.now - time_start ) )
  end

  def self.logger
    @@logger ||= Logger.new(PictureProcess::LOGGER_FILE)
  end
end
