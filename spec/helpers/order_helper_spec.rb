# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OrderHelper do

  it "should return the tacking code link" do
    order = stub(:number => order_number = 1234, :invoice_number => invoice_number = "12345")
    expected = "http://tracking.totalexpress.com.br/poupup_track.php?reid=1537&pedido=#{order_number}&nfiscal=#{invoice_number}"
    helper.link_to_tracking_code(order).should == expected
  end
end
