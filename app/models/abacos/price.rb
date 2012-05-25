# -*- encoding : utf-8 -*-
module Abacos
  class Price
    attr_reader :integration_protocol, :number, :price, :retail_price

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end
    
    def integrate
      variant = ::Variant.find_by_number(self.number)
      raise RuntimeError.new "Price is related with Variant number #{self.number}, but it doesn't exist" if variant.nil?
      
      variant.price = self.price
      variant.retail_price = self.retail_price
      if variant.save!
        CatalogService.save_product variant.product, :update_price => true
      end

      Abacos::ProductAPI.confirm_price(self.integration_protocol)
    end

    def self.parse_abacos_data(abacos_product)
      { integration_protocol: abacos_product[:protocolo_preco],
        number:               abacos_product[:codigo_produto],
        price:                abacos_product[:preco_tabela].to_f,
        retail_price:         abacos_product[:preco_promocional].to_f
      }
    end
  end
end
