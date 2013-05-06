class ProductSearchWorker

  def self.perform
    index_products
  end

  private

    def self.index_products
      Product.where(is_visible: true).each do |product|
        index product
      end
    end

    def self.index product
      ProductSearch.index_term(product.formatted_name(100))
      product.name.split.each { |t| ProductSearch.index_term(t) }
    end
end
