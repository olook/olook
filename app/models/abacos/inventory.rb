# -*- encoding : utf-8 -*-
module Abacos
  class Inventory
    attr_reader :integration_protocol, :number, :inventory

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_estoque]
      @number = abacos_product[:codigo_produto]
      @inventory = abacos_product[:saldo_disponivel].to_i
    end
  end
end
