class ProductSearch

  def self.terms_for(term)
    return [] if term.size < 3
    REDIS.zrevrange CACHE_KEYS[:product_search][:key] % term.downcase, 0, 9
  end

  def self.index_term(term)
    1.upto(term.to_s.length - 1) do |n|
      prefix = term.downcase[0, n]
      REDIS.zincrby CACHE_KEYS[:product_search][:key] % prefix, 1, term.downcase
    end
  end

end
