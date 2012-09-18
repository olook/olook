# -*- encoding : utf-8 -*-
require 'iconv'
class Checkout::PaymentsController < ActionController::Base
  protect_from_forgery :except => :create

  def create
    payment = Payment.find_by_identification_code(params["id_transacao"])
    order = payment.try(:order)

    MoipCallback.create(:order_id => order.try(:id),
                        :cod_moip => params["cod_moip"],
                        :tipo_pagamento => params["tipo_pagamento"],
                        :status_pagamento => params["status_pagamento"],
                        :id_transacao => params["id_transacao"],
                        :classificacao => Iconv.conv('UTF-8//IGNORE', "US-ASCII", params["classificacao"]),
                        :payment_id => payment.try(:id))
    if payment
      payment.update_attributes!(:gateway_code   => params["cod_moip"],
                              :gateway_type   => params["tipo_pagamento"],
                              :gateway_status => params["status_pagamento"],
                              :gateway_status_reason => Iconv.conv('UTF-8//IGNORE', "US-ASCII", params["classificacao"]))

       Resque.enqueue_in(1.minute, SetPaymentStatusWorker, payment.id, params["status_pagamento"])
    end
    render :nothing => true, :status => 200
  end
end
