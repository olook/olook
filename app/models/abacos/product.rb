# -*- encoding : utf-8 -*-
module Abacos
  class Product
    include ::Abacos::Helpers

    attr_reader :name, :model_name, :category,
                :width, :height, :length, :weight,
                :color

    def initialize(abacos_product)
      @name = abacos_product[:nome_produto]
      @model_name = abacos_product[:codigo_produto].to_s
      @category = parse_category(abacos_product[:descricao_classe])
      @width = abacos_product[:largura].to_f
      @height = abacos_product[:espessura].to_f
      @length = abacos_product[:comprimento].to_f
      @weight = abacos_product[:peso].to_f
      @color = parse_color( abacos_product[:descritor_pre_definido] )
    end

  private
    def parse_category(abacos_category)
      case abacos_category.strip
        when 'Sapato' then Category::SHOE
        when 'Bolsa' then Category::BAG
        when 'Jóia' then Category::JEWEL
      else
        Category::SHOE
      end
    end
    
    def parse_color(abacos_descritor_pre_definido)
      find_in_descritor_pre_definido(abacos_descritor_pre_definido, 'COR')
    end
  end
end
