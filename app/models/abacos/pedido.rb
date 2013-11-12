# -*- encoding : utf-8 -*-
module Abacos
  class Pedido
    include ::Abacos::Helpers

    attr_reader :numero, :codigo_cliente, :cpf, :nome, :email, :telefone,
                :data_venda, :valor_pedido, :valor_desconto, :valor_frete,
                :transportadora, :tempo_entrega, :data_entrega, :endereco, :itens, :pagamento, :nota_simbolica, :valor_embalagem, :anotacao_pedido

    def initialize(order)
      @numero           = order.number

      @codigo_cliente   = "F#{order.user.id}"
      @cpf              = order.user_cpf =~ /\// ? parse_cnpj(order.user_cpf) : parse_cpf(order.user_cpf)
      @nome             = order.user_name
      @email            = order.user_email

      @telefone         = parse_telefone(order.freight.telephone)

      @data_venda       = parse_data(order.created_at)
      
      #TODO USAR VALOR CORRETO
      @valor_pedido     = parse_price order.subtotal #valor do retailprice
      @valor_desconto   = parse_price order.amount_discount #valor do discount burto
      @valor_frete      = parse_price order.freight_price
      @transportadora   = order.freight.shipping_service.erp_code
      @tempo_entrega    = order.freight.delivery_time
      @data_entrega     = parse_data_entrega(order.freight.delivery_time)

      @endereco         = parse_endereco(order.freight)
      @itens            = parse_itens(order.line_items)
      @pagamento        = parse_pagamento(order)
    end

    def parsed_data
      result = {
        'ListaDePedidos' => {
          'DadosPedidos' => {
            'NumeroDoPedido'           => @numero,
            'CodigoCliente'            => @codigo_cliente,
            'RepresentanteVendas'      => 'SITE',
            'CPFouCNPJ'                => @cpf,
            'DataVenda'                => @data_venda,
            'DestNome'                 => @nome,
            'DestEmail'                => @email,
            'DestTelefone'             => @telefone,
            'ValorPedido'              => @valor_pedido,
            'ValorDesconto'            => @valor_desconto,
            'ValorFrete'               => @valor_frete,
            'Transportadora'           => @transportadora,
            'PrazoEntregaPosPagamento' => @tempo_entrega,
            'DataPrazoEntregaInicial'  => @data_entrega,
            'Itens' => {
              'DadosPedidosItem'       => @itens.map {|item| item.parsed_data}
            },
            'FormasDePagamento'        => @pagamento.parsed_data
          }
        }
      }

      result['ListaDePedidos']['DadosPedidos'].merge! @endereco.parsed_data('Dest')
      result
    end

  private

    def parse_data_entrega(delivery_time)
      "#{delivery_time.business_days.from_now.strftime("%d%m%Y")} 21:00"
    end

    def parse_itens(line_items)
      line_items.map do |line_item|
        Abacos::Item.new(line_item)
      end
    end

    def parse_pagamento(order)
      Abacos::Pagamento.new order
    end
  end
end
