# -*- encoding : utf-8 -*-
module Abacos
  class Product
    attr_reader :name, :model_name, :category, :price, :width, :height, :length, :weight

    def initialize(abacos_product)
      @name = abacos_product[:nome_produto]
      @model_name = abacos_product[:codigo_produto].to_s
      @category = parse_category(abacos_product[:descricao_classe])
      @price = abacos_product[:preco_tabela_1].to_f
      @width = abacos_product[:largura].to_f
      @height = abacos_product[:espessura].to_f
      @length = abacos_product[:comprimento].to_f
      @weight = abacos_product[:peso].to_f
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
  end
end
