# -*- encoding : utf-8 -*-
module Abacos
  class CancelarPedido
    include Helpers

    attr_reader :numero_pedido, :data, :status, :codigo_autorizacao,
                :mensagem_retorno, :codigo_retorno

    def initialize(order)
      raise "Order number #{order.number} isn't canceled" unless order.canceled?
      @numero_pedido      = order.number
      @data               = parse_datetime(order.erp_payment.created_at)
      @status             = 'speRecusado'
      @codigo_autorizacao = order.erp_payment.gateway_transaction_code
      @mensagem_retorno   = order.erp_payment.gateway_message
      @codigo_retorno     = order.erp_payment.gateway_return_code
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
  end
end
