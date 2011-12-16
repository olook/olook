# -*- encoding : utf-8 -*-
module Abacos
  class Pedido
    include ::Abacos::Helpers

    attr_reader :numero, :codigo_cliente, :cpf, :nome, :email, :telefone,
                :data_venda, :valor_pedido, :valor_desconto, :valor_frete,
                :transportadora, :endereco, :itens, :pagamento

    def initialize(order)
      @numero           = order.number

      @codigo_cliente   = "F#{order.user.id}"
      @cpf              = parse_cpf(order.user.cpf)
      @nome             = order.user.name
      @email            = order.user.email

      @telefone         = parse_telefone(order.freight.address.telephone)

      @data_venda       = parse_data(order.created_at)

      @valor_pedido     = parse_price order.line_items_total
      @valor_desconto   = parse_price order.credits
      @valor_frete      = parse_price order.freight_price
      @transportadora   = 'TEX'
      
      @endereco         = parse_endereco(order.freight.address)
      @itens            = parse_itens(order.line_items)
      @pagamento        = parse_pagamento(order)
    end
    
    def parsed_data
      result = {
        'ListaDePedidos'        => {
          'DadosPedidos'        => {
            'NumeroDoPedido'    => @numero,
            'CodigoCliente'     => @codigo_cliente,
            'CPFouCNPJ'         => @cpf,
            'DataVenda'         => @data_venda,
            'DestNome'          => @nome,
            'DestEmail'         => @email,
            'DestTelefone'      => @telefone,

            'ValorPedido'       => @valor_pedido,
            'ValorDesconto'     => @valor_desconto,
            'ValorFrete'        => @valor_frete,
            'Transportadora'    => @transportadora,

            'Itens'             =>
              {'DadosPedidosItem' => @itens.map {|item| item.parsed_data} },
            'FormasDePagamento' => @pagamento.parsed_data
          }
        }
      }
      
      result['ListaDePedidos']['DadosPedidos'].merge! @endereco.parsed_data('Dest')
      result
    end
  private
    def parse_itens(line_items)
      line_items.map do |line_item|
        Abacos::Item.new( line_item )
      end
    end
    
    def parse_pagamento(order)
      Abacos::Pagamento.new order
    end
  end
end
