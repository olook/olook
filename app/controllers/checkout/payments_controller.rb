# -*- encoding : utf-8 -*-
require 'iconv'
class Checkout::PaymentsController < ActionController::Base
  protect_from_forgery :except => :create

  def create
    payment = Payment.find_by_identification_code(params["id_transacao"])

    MoipCallback.create!(:cod_moip => params["cod_moip"],
                         :tipo_pagamento => params["tipo_pagamento"],
                         :status_pagamento => params["status_pagamento"],
                         :id_transacao => params["id_transacao"],
                         :classificacao => Iconv.conv('UTF-8//IGNORE', "US-ASCII", params["classificacao"]),
                         :payment_id => payment.try(:id))

    render :nothing => true, :status => 200
  end
end

