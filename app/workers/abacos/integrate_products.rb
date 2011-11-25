# -*- encoding : utf-8 -*-
module Abacos
  class IntegrateProducts
    @queue = :integrate_products

    def self.perform
      abacos_products = DownloadProducts.download_products
      
      abacos_products.each do |abacos_product|
        product = parse_abacos_product(abacos_product)
        product.integrate
      end
    end
    
    def self.parse_abacos_product(abacos_product)
      if abacos_product[:codigo_produto_pai].nil?
        Abacos::Product.new abacos_product
      else
        Abacos::Variant.new abacos_product
      end
    end
  end
end
