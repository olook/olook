# -*- encoding : utf-8 -*-
module Abacos
  class Pagamento
    include Helpers

    attr_reader :valor, :forma, :parcelas, :boleto_vencimento

    def initialize(order)
      @valor    = parse_price order.total_with_freight
      @forma    = order.payment.is_a?(Billet) ? 'BOLETO' : order.payment.bank.upcase
      @parcelas = order.payment.payments || 1
      @boleto_vencimento = parse_expiration_date(order.payment.payment_expiration_date) if order.payment.is_a?(Billet)
    end

    def parsed_data
      {
        'DadosPedidosFormaPgto' => {
          'Valor'                 => @valor,
          'CartaoQtdeParcelas'    => @parcelas,
          'FormaPagamentoCodigo'  => @forma,
          'BoletoVencimento' => @boleto_vencimento
        }
      }
    end

    private

    def parse_expiration_date(date)
      date.strftime("%d%m%Y")
    end
  end
end
