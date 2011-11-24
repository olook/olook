# -*- encoding : utf-8 -*-
module Abacos
  class Price
    attr_reader :integration_protocol, :number, :price

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_preco]
      @number = abacos_product[:codigo_produto]
      @price = abacos_product[:preco_tabela].to_f
    end
  end
end
