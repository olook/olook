# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OrderHelper do

  subject do
    FactoryGirl.create(:delivered_order)
  end

  it "should return the tracking code link for TEX" do
    expected = "http://tracking.totalexpress.com.br/poupup_track.php?reid=1537&pedido=#{subject.number}&nfiscal=#{subject.invoice_number}"
    helper.link_to_tracking_code(subject).should == expected
  end

  it "should return the tracking code link for PAC" do
    subject.freight.shipping_service = FactoryGirl.create(:pac)
    expected = "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=#{subject.freight.tracking_code}"
    helper.link_to_tracking_code(subject).should == expected
  end

end
