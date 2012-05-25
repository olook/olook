# -*- encoding : utf-8 -*-
module Abacos
  class PedidoPresente < Pedido

  	def initialize(order)
      super(order)
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

  end
end