module Catalogs
  class MomentStrategy

    def initialize product, options = {}
      @product = product
      @options = options.dup
      @options[:moments] ||= []
      @moments = @options.delete(:moments)
    end

    def save
      @moments.each do |moment|
        ct_product_service = CatalogProductService.new moment.catalog, @product, @options
        ct_product_service.save!
      end
    end

    def destroy
      catalogs = Catalog::Product.where(:product_id => @product.id).group(:catalog_id).map{|cp| cp.catalog.moment}
      (catalogs - @moments).each do |moment|
        ct_product_service = CatalogProductService.new moment.catalog, @product, @options
        ct_product_service.destroy
      end
    end

    def seek_and_destroy!
      self.save
      self.destroy
    end
  end
end
