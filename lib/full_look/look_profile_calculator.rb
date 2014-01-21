module FullLook
  class LookProfileCalculator
    def self.calculate products, options={}
      category_weight = options[:category_weight]
      profile_count = products.inject({}) do |h, product|
        product.profiles.each do |profile|
          h[profile.id] ||= 0
          if category_weight
            h[profile.id] += category_weight[product.category]
          else
            h[profile.id] += 1
          end
        end
        h
      end
      profile_count.to_a.sort { |a, b| b.last <=> a.last }.first.first
    end
  end
end
