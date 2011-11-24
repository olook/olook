# -*- encoding : utf-8 -*-
module Abacos
  class Variant
    include ::Abacos::Helpers

    attr_reader :integration_protocol,
                :model_number, :number, :description

    def initialize(abacos_product)
      @integration_protocol = abacos_product[:protocolo_produto]
      @model_number = abacos_product[:codigo_produto_pai]
      @number = abacos_product[:codigo_produto]
      @description = parse_description( abacos_product[:descritor_pre_definido] )
    end

  private
    def parse_description(abacos_descritor_pre_definido)
      find_in_descritor_pre_definido(abacos_descritor_pre_definido, 'TAMANHO')
    end
  end
end
