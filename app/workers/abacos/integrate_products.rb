# -*- encoding : utf-8 -*-
module Abacos
  class IntegrateProducts
    @queue = :abacos_to_front

    def self.perform
      process_products
      process_inventory
      process_prices
    end

  private
    def self.process_products
      ProductAPI.download_products.each do |abacos_product|
        parsed_class = parse_product_class(abacos_product)
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
        parsed_class = parse_price_class(abacos_price)
        parsed_data = parsed_class.parse_abacos_data(abacos_price)
        Resque.enqueue(Abacos::Integrate, parsed_class.to_s, parsed_data)
      end
    end
    
  private
    def self.parse_product_class(abacos_product)
      abacos_product[:codigo_produto_pai].nil? ? Abacos::Product : Abacos::Variant
    end
    def self.parse_price_class(abacos_product)
      abacos_product[:codigo_produto_pai].nil? ? Abacos::ProductPrice : Abacos::VariantPrice
    end
  end
end
