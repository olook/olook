class MercadoPagoController < ApplicationController

  def create
    begin
      response = MP.get_payment_info params[:id]
      mp_transaction = response['response']['collection']

      status = mp_transaction['status']
      if status == 'approved'
        order_number = mp_transaction['external_reference']
        order = Order.find_by_number order_number
        order.erp_payment.authorize
      end

      render json: {status: :ok}.to_json
    rescue
      render json: {status: :bad_request}.to_json
    end
  end

end
