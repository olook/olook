# -*- encoding : utf-8 -*-
module Abacos
  class ProductPrice
    attr_reader :integration_protocol, :model_number, :price

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end
    
    def integrate
      product = ::Product.find_by_model_number(self.model_number)
      raise RuntimeError.new "Price is related with Product model number #{self.model_number}, but it doesn't exist" if product.nil?
      
      product.price = self.price
      product.save!

      confirm_price
    end
    
    def confirm_price
      Resque.enqueue(Abacos::ConfirmPrice, self.integration_protocol)
    end

    def self.parse_abacos_data(abacos_product)
      { integration_protocol: abacos_product[:protocolo_preco],
        model_number:         abacos_product[:codigo_produto],
        price:                abacos_product[:preco_tabela].to_f }
    end
  end
end
