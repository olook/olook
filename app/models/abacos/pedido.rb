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
      @cpf              = parse_cpf(order.user.cpf)
      @nome             = order.user.name
      @email            = order.user.email

      @telefone         = parse_telefone(order.freight.address.telephone)

      @data_venda       = parse_data(order.created_at)

      @valor_pedido     = parse_price order.line_items_total
      @valor_desconto   = parse_price discount_for(order)
      @valor_frete      = parse_price order.freight_price
      @transportadora   = 'TEX'
      @tempo_entrega    = order.freight.delivery_time
      @data_entrega     = parse_data_entrega(order.freight.delivery_time)

      @endereco         = parse_endereco(order.freight.address)
      @itens            = parse_itens(order.line_items)
      @pagamento        = parse_pagamento(order)

      @nota_simbolica   = order.gift_wrap?
      @valor_embalagem  = order.gift_wrap? ? YAML::load_file(Rails.root.to_s + '/config/gifts.yml')["values"][0] : false
      @anotacao_pedido  = order.gift_wrap? ? order.gift_message : false
    end

    def parsed_data
      result = {
        'ListaDePedidos' => {
          'DadosPedidos' => {
            'NumeroDoPedido'           => @numero,
            'CodigoCliente'            => @codigo_cliente,
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

            'EmitirNotaSimbolica'      => @nota_simbolica,
            'ValorEmbalagemPresente'   => @valor_embalagem,
            'Anotacao1'                => @anotacao_pedido,

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
      "#{delivery_time.days.from_now.strftime("%d%m%Y")} 21:00"
    end

    def discount_for(order)
      if (order.line_items_total - order.total_discount) < Payment::MINIMUM_VALUE
        total_discount = order.line_items_total - Payment::MINIMUM_VALUE
      else
        total_discount = order.total_discount
      end
      total_discount
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
