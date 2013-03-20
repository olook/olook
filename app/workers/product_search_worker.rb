class ProductSearchWorker

  def self.perform
    index_products
  end

  private

    def self.index_products
      Product.where(is_visible: true).each do |product|
        ProductSearch.index_term(product.name)
        product.name.split.each { |t| ProductSearch.index_term(t) }
      end
    end

end
