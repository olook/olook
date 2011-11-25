# -*- encoding : utf-8 -*-
module Abacos
  module Helpers
    def find_in_descritor_pre_definido(data, query)
      items = data[:rows][:dados_descritor_pre_definido]
      
      items = [items] unless items.is_a? Array
      
      items.each do |item|
        return item[:descricao].strip if item[:grupo_nome].strip == query
      end
      ''
    end

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
