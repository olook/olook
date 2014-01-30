module Recommended
  class OrganizedProducts
    def self.organize products
      @shoe = products.select{|s| s.category == 1}
      @bag = products.select{|s| s.category == 2}
      @accessory = products.select{|s| s.category == 3}
      @cloth = products.select{|s| s.category == 4}
       [@shoe,@bag,@accessory,@cloth].max_by{|x| x.size}



      organize = products.inject({}) {|h,hv| h[hv.category] ||= [];h[hv.category] += [hv];h}
      (1..6)
      organize
    end
  end
end
