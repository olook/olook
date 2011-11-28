# -*- encoding : utf-8 -*-
module Abacos
  class Variant
    include ::Abacos::Helpers

    attr_reader :integration_protocol,
                :model_number, :number, :description, :display_reference

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_produto]
      @model_number = abacos_product[:codigo_produto_pai]
      @number = abacos_product[:codigo_produto]
      @description = parse_description( abacos_product[:descritor_pre_definido] )
      
      category = parse_category(abacos_product[:descricao_classe])
      @display_reference = parse_display_reference(@description, category)
    end
    
    def attributes
      { number:             self.number,
        description:        self.description,
        display_reference:  self.display_reference,
        is_master:          false }
    end
    
    def integrate
      product = ::Product.find_by_model_number(self.model_number)
      raise RuntimeError.new "Product with model_number #{self.model_number} is related to variant number #{self.number} but it doesn't exist" if product.nil?
      
      variant = product.variants.find_by_number(self.number) || product.variants.build
      variant.update_attributes(self.attributes)

      variant.save!
      
      Abacos::ProductAPI.confirm_product(self.integration_protocol)
    end

  private
    def parse_description(abacos_descritor_pre_definido)
      find_in_descritor_pre_definido(abacos_descritor_pre_definido, 'TAMANHO')
    end
    
    def parse_display_reference(description, category)
      category == Category::SHOE ? "size-#{description}" : 'single-size'
    end
  end
end
