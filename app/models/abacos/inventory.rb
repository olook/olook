# -*- encoding : utf-8 -*-
module Abacos
  class Inventory
    attr_reader :integration_protocol, :number, :inventory

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end
    
    def integrate
      variant = ::Variant.find_by_number(self.number)
      raise RuntimeError.new "Inventory is related with Variant number #{self.number}, but it doesn't exist" if variant.nil?
      
      variant.inventory = self.inventory
      variant.save!

      confirm_inventory
    end
    
    def confirm_inventory
      Resque.enqueue(Abacos::ConfirmInventory, self.integration_protocol)
    end

    def self.parse_abacos_data(abacos_product)
      { integration_protocol: abacos_product[:protocolo_estoque],
        number:               abacos_product[:codigo_produto],
        inventory:            abacos_product[:saldo_disponivel].to_i }
    end
  end
end
