# -*- encoding : utf-8 -*-
module Abacos
  class IntegrateProducts
    @queue = :integrate_products

    def self.perform
      process_products
      process_inventory
      process_prices
    end

  private
    def self.process_products
      ProductAPI.download_products.each do |abacos_product|
        parsed_class = parse_class(abacos_product)
        parsed_data = parsed_class.parse_abacos_data(abacos_product)
        Resque.enqueue(Abacos::Integrate, parsed_class.to_s, parsed_data)
      end
    end

    def self.process_inventory
      ProductAPI.download_inventory.each do |abacos_inventory|
        parsed_data = Abacos::Inventory.parse_abacos_data(abacos_inventory)
        Resque.enqueue(Abacos::Integrate, Abacos::Inventory.to_s, parsed_data)
      end
    end
    
    def self.process_prices
      ProductAPI.download_prices.each do |abacos_price|
        parsed_data = Abacos::Price.parse_abacos_data(abacos_price)
        Resque.enqueue(Abacos::Integrate, Abacos::Price.to_s, parsed_data)
      end
    end
    
    def self.parse_class(abacos_product)
      abacos_product[:codigo_produto_pai].nil? ? Abacos::Product : Abacos::Variant
    end
  end
end
