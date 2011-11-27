# -*- encoding : utf-8 -*-
module Abacos
  class Product
    include ::Abacos::Helpers

    attr_reader :integration_protocol,
                :name, :model_number, :category,
                :width, :height, :length, :weight,
                :color, :details, :profiles

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_produto]
      @name = abacos_product[:nome_produto]
      @model_number = abacos_product[:codigo_produto].to_s
      @category = parse_category(abacos_product[:descricao_classe])
      @width = abacos_product[:largura].to_f
      @height = abacos_product[:espessura].to_f
      @length = abacos_product[:comprimento].to_f
      @weight = abacos_product[:peso].to_f
      @color = parse_color( abacos_product[:descritor_pre_definido] )
      @details = parse_details( abacos_product[:caracteristicas_complementares] )
      @profiles = parse_profiles( abacos_product[:caracteristicas_complementares] )
    end
    
    def attributes
      { name:         self.name,
        model_number: self.model_number,
        category:     self.category,
        width:        self.width,
        height:       self.height,
        length:       self.length,
        weight:       self.weight }
    end
    
    def integrate
      product = ::Product.find_by_model_number(self.model_number) || ::Product.new

      product.update_attributes(self.attributes)
      product.description ||= self.name

      product.save!
      
      Abacos::ProductAPI.confirm_product(self.integration_protocol)
    end

  private
    def parse_color(data)
      find_in_descritor_pre_definido(data, 'COR')
    end
    
    def parse_details(data)
      items = data[:rows][:dados_caracteristicas_complementares]
      items = [items] unless items.is_a? Array
      
      {}.tap do |result|
        items.each do |item|
          next if item[:tipo_nome].strip == 'Perfil'
          result[ item[:tipo_nome].strip ] = item[:texto].strip
        end
      end
    end

    def parse_profiles(data)
      items = data[:rows][:dados_caracteristicas_complementares]
      items = [items] unless items.is_a? Array

      result = []
      items.each do |item|
        if item[:tipo_nome].strip == 'Perfil'
          result += item[:texto].split(',')
        end
      end
      result.map &:strip
    end
  end
end
