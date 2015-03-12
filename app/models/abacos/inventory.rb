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
      if variant.present?
        variant.inventory = self.inventory
        variant.update_initial_inventory_if_needed
        variant.save!
      end

      confirm_inventory
    end
    
    def confirm_inventory
      # Abacos::ProductAPI.confirm_inventory self.integration_protocol
      
      # Temporary executing in sync
      Resque.enqueue(Abacos::ConfirmInventory, self.integration_protocol)
    end

    def self.parse_abacos_data(abacos_inventory)
      { integration_protocol: abacos_inventory[:protocolo_estoque],
        number:               abacos_inventory[:codigo_produto],
        inventory:            abacos_inventory[:saldo_disponivel].to_i }
    end
  end
end
