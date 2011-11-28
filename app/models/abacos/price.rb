# -*- encoding : utf-8 -*-
module Abacos
  class Price
    attr_reader :integration_protocol, :number, :price

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_preco]
      @number = abacos_product[:codigo_produto]
      @price = abacos_product[:preco_tabela].to_f
    end

    def integrate
      variant = ::Variant.find_by_number(self.number)
      raise RuntimeError.new "Price is related with Variant number #{self.number}, but it doesn't exist" if variant.nil?
      
      variant.price = self.price
      variant.save!

      Abacos::ProductAPI.confirm_price(self.integration_protocol)
    end
  end
end
