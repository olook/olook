class MercadoPagoController < ApplicationController

  def create
    begin
      log("IPN received [id=#{params[:id]}]")

      response = MP.get_payment_info params[:id]
      mp_transaction = response['response']['collection']
      order_number = mp_transaction['external_reference']
      status = mp_transaction['status']

      log("order_number=#{order_number}, status=#{status}")

      order = Order.find_by_number order_number
      mercado_pago_payment = order.erp_payment
      mercado_pago_payment.update_attribute(:mercado_pago_id, params[:id])
      
      if status == 'approved'
        mercado_pago_payment.authorize
      end

      log("IPN handled successfully")
      render json: {status: :ok}.to_json
    rescue => e
      log("Error on handling IPN id=#{params[:id]}: #{e}")
      render json: {status: :bad_request}.to_json
    end
  end

  private
    def log msg
      Rails.logger.info("[MERCADOPAGO] #{msg}")
    end
end