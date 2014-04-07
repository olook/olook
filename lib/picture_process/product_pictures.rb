class PictureProcess::ProductPictures
  @queue = 'low'
  class ProductNotFound < StandardError; end
  def self.perform(key, pictures)
    time_start = Time.zone.now
    logger.debug("Initializing PictureProcess for product #{key} with #{pictures.size} pictures")
    product = Product.find_by_id key

    still = pictures.find { |image| /still/i =~ image }
    product.remote_picture_for_xml_url = still if still

    sample = pictures.find { |image| /sample/i =~ image }
    product.remote_color_sample_url = sample if sample

    product.save

    product.pictures.destroy_all if product.pictures.count > 1
    _pics = pictures.select { |image| %r{/[\d-]+\.jpe?g$}i =~ image }.sort
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
