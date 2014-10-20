# -*- encoding : utf-8 -*-
require 'iconv'
class Checkout::PaymentCallbacksController < ActionController::Base
  protect_from_forgery :except => :create

  def create_moip
    payment = Payment.find_by_identification_code(params["id_transacao"])

    MoipCallback.create!(:cod_moip => params["cod_moip"],
                         :tipo_pagamento => params["tipo_pagamento"],
                         :status_pagamento => params["status_pagamento"],
                         :id_transacao => params["id_transacao"],
                         :classificacao => Iconv.conv('UTF-8//IGNORE', "US-ASCII", params["classificacao"]),
                         :payment_id => payment.try(:id))

    render :nothing => true, :status => 200
  end

  def billet
    if billet = Billet.find_by_identification_code(params[:identification_code])
      begin
        billet.authorize unless billet.state == "authorized"
        render :nothing => true, status: :ok
      rescue => e
        Airbrake.notify(
          :error_class   => "Checkout::PaymentCallbacksController",
          :error_message => "billet: the following error occurred: #{e.message}"
        )
        head :error, content_type: :json
      end
    else
      head :not_found, content_type: :json
    end
  end

  def debit
    if debit = Debit.find_by_id(params[:payment_id])
      begin
        debit.authorize unless debit.state == "authorized"
        render :nothing => true, status: :ok
      rescue => e
        Airbrake.notify(
          :error_class   => "Checkout::PaymentCallbacksController",
          :error_message => "debit: the following error occurred: #{e.message}"
        )
        head :error, content_type: :json
      end
    else
      head :not_found, content_type: :json
    end
  end

end
