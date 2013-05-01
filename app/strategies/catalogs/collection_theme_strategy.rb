module Catalogs
  class CollectionThemeStrategy

    def initialize product, options = {}
      @product = product
      @options = options.dup
      @options[:collection_themes] ||= []
      @collection_themes = @options.delete(:collection_themes)
    end

    def save
      @collection_themes.each do |collection_theme|
        ct_product_service = CatalogProductService.new collection_theme.catalog, @product, @options
        ct_product_service.save!
      end
    end

    def destroy
      collection_themes = Catalog::Product.where(:product_id => @product.id).group(:catalog_id).map{|cp| cp.catalog.collection_theme}
      (collection_themes - @collection_themes).each do |collection_theme|
        ct_product_service = CatalogProductService.new collection_theme.catalog, @product, @options
        ct_product_service.destroy
      end
    end

    def seek_and_destroy!
      self.save
      self.destroy
    end
  end
end
