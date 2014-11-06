# -*- encoding : utf-8 -*-
module Abacos
  class Credito
    include Helpers

    attr_reader :valor

    def initialize(amount)
      @valor = parse_price amount
    end

    def parsed_data
      {
        'DadosPedidosFormaPgto' => {
          'Valor'                => @valor,
          'CartaoQtdeParcelas'   => 1,
          'FormaPagamentoCodigo' => "CREDITO DE ESTORNO"
        }
      }
    end

  end
end
