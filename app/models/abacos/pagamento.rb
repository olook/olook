# -*- encoding : utf-8 -*-
module Abacos
  class Pagamento
    include Helpers

    attr_reader :valor, :forma, :parcelas

    def initialize(order)
      @valor    = parse_price order.total_with_freight
      @forma    = order.payment.is_a?(Billet) ? 'BOLETO' : order.payment.bank.upcase
      @parcelas = order.payment.payments || 1
    end
    
    def parsed_data
      {
        'DadosPedidosFormaPgto' => {
          'Valor'                 => @valor,
          'CartaoQtdeParcelas'    => @parcelas,
          'FormaPagamentoCodigo'  => @forma
        }
      }
    end
  end
end
