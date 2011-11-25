# -*- encoding : utf-8 -*-
module Abacos
  module Helpers
    def find_in_descritor_pre_definido(abacos_descritor_pre_definido, query)
      items = abacos_descritor_pre_definido[:rows][:dados_descritor_pre_definido]
      
      items = [items] if items.is_a? Hash
      
      items.each do |item|
        return item[:descricao].strip if item[:grupo_nome].strip == query
      end
      ''
    end
  end
end
