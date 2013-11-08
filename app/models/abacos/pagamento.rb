# -*- encoding : utf-8 -*-
module Abacos
  class Pagamento
    include Helpers

    attr_reader :valor, :forma, :parcelas, :boleto_vencimento

    def initialize(order)
      @valor             = parse_price order.amount_paid
      @forma             = parse_bank(order)
      @parcelas          = order.erp_payment.payments || 1
      @boleto_vencimento = parse_expiration_date(order.erp_payment.payment_expiration_date) if order.erp_payment.is_a?(Billet)
    end

    def parsed_data
      {
        'DadosPedidosFormaPgto' => {
          'Valor'                => @valor,
          'CartaoQtdeParcelas'   => @parcelas,
          'FormaPagamentoCodigo' => @forma,
          'BoletoVencimento'     => @boleto_vencimento
        }
      }
    end

    private

    def parse_bank order
      if order.erp_payment.is_a?(Billet) 
        'BOLETO' 
      elsif order.erp_payment.is_a?(MercadoPagoPayment)
        'MERCADO PAGO'
      else
       order.erp_payment.bank.upcase
     end
    end

    def parse_expiration_date(date)
      date.strftime("%d%m%Y")
    end
  end
end
