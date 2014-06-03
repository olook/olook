class ReprocessingProductPicturesVersions
  @queue = 'calhau'
  def self.perform(product_id)
    product = Product.find_by_id(product_id)
    return unless product

    product.pictures.each do |pic|
      pic.image.recreate_versions!
      pic.save
    end
  end
end
