# -*- encoding : utf-8 -*-
require 'boleto_bancario'
class Checkout::BilletsController < ApplicationController
  before_filter :authenticate_user!
  layout false

  def show
    config = SANTANDER
    if payment = current_user.payments.find(params[:id])
      @boleto = BoletoBancario::Core::Santander.new do |boleto_santander|
        boleto_santander.conta_corrente        = config['conta_corrente']
        boleto_santander.digito_conta_corrente = config['digito_conta_corrente']
        boleto_santander.agencia               = config['agencia']
        boleto_santander.carteira              = config['carteira']
        boleto_santander.cedente               = config['cedente']
        boleto_santander.codigo_cedente        = config['codigo_cedente']
        boleto_santander.endereco_cedente      = 'Rua Surubim, 159'
        #TODO: access delivery address through freight
        # boleto_santander.endereco_cedente      = payment.user.delivery_address
        boleto_santander.numero_documento      = payment.order.number
        boleto_santander.sacado                = "#{payment.user.first_name} #{payment.user.last_name}"
        boleto_santander.documento_sacado      = payment.user.cpf
        boleto_santander.data_vencimento       = 2.business_days.from_now.to_date
        boleto_santander.valor_documento       = payment.total_paid
      end
    else
      render :status => :not_found
    end
  end
end