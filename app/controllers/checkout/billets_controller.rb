# -*- encoding : utf-8 -*-
require 'boleto_bancario'
class Checkout::BilletsController < ApplicationController
  before_filter :authenticate_user!
  layout false

  def show
    if payment = current_user.payments.find(params[:id])
      @boleto = BoletoBancario::Core::Santander.new do |boleto_santander|
        boleto_santander.conta_corrente        = '013002564'
        boleto_santander.digito_conta_corrente = '8'
        boleto_santander.agencia               = '3413'
        boleto_santander.carteira              = '102'
        boleto_santander.cedente               = 'OLOOK COM ONLINE DE MODA LTDA'
        boleto_santander.codigo_cedente        = '5739454'
        boleto_santander.endereco_cedente      = current_user.delivery_address
        boleto_santander.numero_documento      = payment.order.number
        boleto_santander.sacado                = current_user.name
        boleto_santander.documento_sacado      = current_user.cpf
        boleto_santander.data_vencimento       = 1.business_day.from_now
        boleto_santander.valor_documento       = payment.total
      end
    else
      render :status => :not_found
    end
  end
end