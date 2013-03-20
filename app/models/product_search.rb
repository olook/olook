class ProductSearch

  def self.terms_for(term)
    REDIS.zrevrange "product-search:#{term.downcase}", 0, 9
  end

  def self.index_term(term)
    1.upto(term.to_s.length - 1) do |n|
      prefix = term[0, n]
      REDIS.zincrby "product-search:#{prefix.downcase}", 1, term.downcase
    end
  end

end
