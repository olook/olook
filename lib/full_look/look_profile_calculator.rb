module FullLook
  class LookProfileCalculator
    def self.calculate products, options={}
      category_weight = options[:category_weight] || {}
      profile_count = products.inject({}) do |h, product|
        weight = category_weight[product.category] || 1
        product.profiles.each do |profile|
          h[profile.id] ||= 0
          h[profile.id] += weight
        end
        h
      end
      profile_count.to_a.sort { |a, b| b.last <=> a.last }.first.first
    end
  end
end
