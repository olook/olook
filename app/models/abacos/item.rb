# -*- encoding : utf-8 -*-
module Abacos
  class Item
    attr_reader :codigo, :quantidade, :preco_unitario, :preco_unitario_bruto, :embalagem_presente

    def initialize(line_item, gift=false)
      @codigo               = line_item.variant.number
      @quantidade           = line_item.quantity
      @preco_unitario       = "%.2f" % (line_item.variant.liquidation? ? line_item.retail_price : line_item.price)
      @preco_unitario_bruto = "%.2f" % line_item.price
      @embalagem_presente   = line_item.gift_wrap?
    end
    
    def parsed_data
      {
        'CodigoProduto'      => @codigo,
        'QuantidadeProduto'  => @quantidade,
        'PrecoUnitario'      => @preco_unitario,
        'PrecoUnitarioBruto' => @preco_unitario_bruto,
        'EmbalagemPresente'  => @embalagem_presente
      }
    end
  end
end
