# -*- encoding : utf-8 -*-
module Abacos
  class Inventory
    attr_reader :integration_protocol, :number, :inventory

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_estoque]
      @number = abacos_product[:codigo_produto]
      @inventory = abacos_product[:saldo_disponivel].to_i
    end
    
    def integrate
      variant = ::Variant.find_by_number(self.number)
      raise RuntimeError.new "Inventory is related with Variant number #{self.number}, but it doesn't exist" if variant.nil?
      
      variant.inventory = self.inventory
      variant.save!

      Abacos::ProductAPI.confirm_inventory(self.integration_protocol)
    end
  end
end
