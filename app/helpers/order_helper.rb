# -*- encoding : utf-8 -*-
module OrderHelper
  def link_to_tracking_code(order)
    "http://tracking.totalexpress.com.br/poupup_track.php?reid=1537&pedido=#{order.number}&nfiscal=#{order.invoice_number}"
  end
end
