# -*- encoding : utf-8 -*-
module Abacos
  class ProductPrice
    attr_reader :integration_protocol, :model_number, :price, :retail_price

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end
    
    def integrate
      product = ::Product.find_by_model_number(self.model_number)
      raise RuntimeError.new "Price is related with Product model number #{self.model_number}, but it doesn't exist" if product.nil?
      
      product.price = self.price
      product.retail_price = self.retail_price

      # alterando a master variant antes do product, senao o preco do product
      # volta a ser o preco antigo que estava com a master_variant (por causa de
        # um monte de callbacks )
      product.master_variant.price = product.price
      product.master_variant.retail_price = product.retail_price
      product.master_variant.save!
      

      if product.save!
        CatalogService.save_product product, :update_price => true
      end

      if product.is_kit
        update_kit_variant_price
      else
        confirm_price
      end

    end
    
    def confirm_price
      Resque.enqueue(Abacos::ConfirmPrice, self.integration_protocol)
    end

    def update_kit_variant_price
      parsed_data = { integration_protocol: self.integration_protocol,
        number:               self.model_number,
        price:                self.price,
        retail_price:         self.retail_price
      }

      Resque.enqueue(Abacos::IntegratePrice, Abacos::VariantPrice.to_s, parsed_data)
    end

    def self.parse_abacos_data(abacos_product)
      { integration_protocol: abacos_product[:protocolo_preco],
        model_number:         abacos_product[:codigo_produto],
        price:                abacos_product[:preco_tabela].to_f,
        retail_price:         abacos_product[:preco_promocional].to_f
      }
    end
  end
end