# -*- encoding : utf-8 -*-
require 'boleto_bancario'
class Checkout::BilletsController < ApplicationController
  layout false
  respond_to :nothing, :only => :reconciliation

  def show
    config = SANTANDER
    if payment = Payment.find(params[:id])
      @boleto = BoletoBancario::Core::Santander.new do |boleto_santander|
        boleto_santander.conta_corrente        = config['conta_corrente']
        boleto_santander.digito_conta_corrente = config['digito_conta_corrente']
        boleto_santander.agencia               = config['agencia']
        boleto_santander.carteira              = config['carteira']
        boleto_santander.cedente               = config['cedente']
        boleto_santander.codigo_cedente        = config['codigo_cedente']
        boleto_santander.endereco_cedente      = 'Rua Natividade, 72'
        #TODO: access delivery address through freight
        # boleto_santander.endereco_cedente      = payment.user.delivery_address
        boleto_santander.numero_documento      = payment.id
        boleto_santander.sacado                = "#{payment.user.first_name} #{payment.user.last_name}"
        boleto_santander.documento_sacado      = payment.user.cpf
        boleto_santander.data_vencimento       = payment.payment_expiration_date.to_date
        boleto_santander.valor_documento       = payment.total_paid.round(2)
      end
      payment.deliver
    else
      render :status => :not_found
    end
  end

  def reconciliation
    if billet = Billet.find_by_identification_code(params[:id])
      begin
        billet.authorize unless billet.state == "authorized"
        render :nothing => true, status: :ok
      rescue => e
        Airbrake.notify(
          :error_class   => "Admin::ProcessBilletFileWorker",
          :error_message => "process_billets: the following error occurred: #{e.message}"
        )
        head :error, content_type: :json
      end
    else
      head :not_found, content_type: :json
    end
  end
end
