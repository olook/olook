class FacebookHighlight
  MAX_SIZE = 3

  def self.products
    product_ids = MktSetting.facebook_products
    SearchEngine.new(product_id: product_ids.to_s.split(/\D/)).with_limit(MAX_SIZE).products
  end

end
