# -*- encoding : utf-8 -*-
module Abacos
  class Item
    attr_reader :codigo, :quantidade, :preco_unitario

    def initialize(line_item)
      @codigo                 = line_item.variant.number
      @quantidade             = line_item.quantity
      @preco_unitario         = "%.2f" % line_item.price
      @preco_unitario_bruto   = "%.2f" % line_item.price
    end
    
    def parsed_data
      {
        'CodigoProduto'       => @codigo,
        'QuantidadeProduto'   => @quantidade,
        'PrecoUnitario'       => @preco_unitario,
        'PrecoUnitarioBruto'  => @preco_unitario_bruto
      }
    end
  end
end
