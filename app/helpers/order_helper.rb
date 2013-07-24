# -*- encoding : utf-8 -*-
module OrderHelper
include ::PurchaseTimeline::Helper

  def link_to_tracking_code(order)
  	case order.freight.shipping_service.erp_code
  	when "TEX"
      "http://tracking.totalexpress.com.br/poupup_track.php?reid=1767&pedido=#{order.number}&nfiscal=#{order.invoice_number}"
  	when "PAC"
      "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=#{order.freight.tracking_code}"
  	when "DTD"
      "http://www.d2d.com.br/tracking/?chave=3047ee053d45323e358c8e5a103a35ff&bc=#{order.number}"
    end
  end
end
