class MercadoPagoController < ApplicationController

  def create
    begin
      log("IPN received [id=#{params[:id]}]")

      response = MP.get_payment_info params[:id]
      mp_transaction = response['response']['collection']
      order_number = mp_transaction['external_reference']
      status = mp_transaction['status']

      log("order_number=#{order_number}, status=#{status}")

      if status == 'approved'
        order = Order.find_by_number order_number
        order.erp_payment.authorize
      end

      log("IPN handled successfully")
      render json: {status: :ok}.to_json
    rescue
      log("Error on handling IPN id=#{params[:id]}")
      render json: {status: :bad_request}.to_json
    end
  end

  private
    def log msg
      Rails.logger.info("[MERCADOPAGO] #{msg}")
    end
end