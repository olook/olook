class ProductSearch
  def self.terms_for(term)
    Product.where("name like ?", "#{term}_%").limit(10).collect(&:name)
  end
end
