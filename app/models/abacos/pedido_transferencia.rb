module Abacos
  class PedidoTransferencia < Pedido

    def parsed_data
      result = super
      result['ListaDePedidos']['DadosPedidos']['ComercializacaoOutrasSaidas'] = 7
      result
    end
  
    private
      def parse_pagamento(order)
        OpenStruct.new(:parsed_data => nil)
      end
  end

end