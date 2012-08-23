# -*- encoding : utf-8 -*-
require 'iconv'
class Checkout::PaymentsController < ApplicationController
  protect_from_forgery :except => :create

  def create
    payment = Payment.find_by_identification_code(params["id_transacao"])
    order = payment.try(:order)
    MoipCallback.create(:order_id => order.try(:id),
                        :cod_moip => params["cod_moip"],
                        :tipo_pagamento => params["tipo_pagamento"],
                        :status_pagamento => params["status_pagamento"],
                        :id_transacao => params["id_transacao"],
                        :cart_id => payment.cart_id)
    if order
      if update_order(order)
        Resque.enqueue(Abacos::CancelOrder, order.number) if order.reload.canceled?
        render :nothing => true, :status => 200
      else
        msg = "Erro ao mudar status do pagamento"
        NewRelic::Agent.add_custom_parameters({:msg => msg, :params => params})
        Airbrake.notify(:error_class => "Payment", :error_message => msg, :parameters => params)
        logger.error(msg)
        logger.error(params)
        render :nothing => true, :status => 500
      end
    else
      msg = "Order não encontrada"
      NewRelic::Agent.add_custom_parameters({:msg => msg, :params => params})
      Airbrake.notify(:error_class => "Order", :error_message => msg, :parameters => params)
      logger.error(msg)
      logger.error(params)
      render :nothing => true, :status => 500
    end
  end

  private

  def update_order(order)
    if order.payment
      order.payment.update_attributes(:gateway_code   => params["cod_moip"],
                                      :gateway_type   => params["tipo_pagamento"],
                                      :gateway_status => params["status_pagamento"],
                                      :gateway_status_reason => Iconv.conv('UTF-8//IGNORE', "US-ASCII", params["classificacao"]))
      order.payment.set_state(params["status_pagamento"])
    end
  end
end
