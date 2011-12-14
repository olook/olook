# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmarPagamento
    include Helpers

    attr_reader :numero_pedido, :data, :status, :codigo_autorizacao,
                :mensagem_retorno, :codigo_retorno

    def initialize(order)
      raise "Payment for order #{order.number} isn't authorized" unless order.payment.authorized?
      @numero_pedido      = order.number
      @data               = parse_datetime(order.payment.payment_response.created_at)
      @status             = 'speConfirmado'
      @codigo_autorizacao = order.payment.payment_response.transaction_code
      @mensagem_retorno   = order.payment.payment_response.message
      @codigo_retorno     = order.payment.payment_response.return_code
    end
    
    def parsed_data
      {
        'NumeroPedido'            => @numero_pedido,
        'DataPagamento'           => @data,
        'StatusPagamento'         => @status,
        'CartaoCodigoAutorizacao' => @codigo_autorizacao,
        'CartaoMensagemRetorno'   => @mensagem_retorno,
        'CartaoCodigoRetorno'     => @codigo_retorno
      }
    end
    
    private

    def parse_datetime(datetime)
      datetime.strftime "%d%m%Y %H:%M:%S"
    end
  end
end
