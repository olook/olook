# -*- encoding : utf-8 -*-
module OrderHelper
  def link_to_tracking_code(order)
  	shipping_service = order.freight.shipping_service.name case
    when "TEX"
      "http://tracking.totalexpress.com.br/poupup_track.php?reid=1537&pedido=#{order.number}&nfiscal=#{order.invoice_number}"
    when "PAC"
      "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=#{order.tracking_code}"
    end
  end
end
