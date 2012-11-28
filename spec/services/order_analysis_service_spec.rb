require 'spec_helper'

describe OrderAnalysisService do
  let(:user) { FactoryGirl.create(:user, :email => "teste@teste.com", :cpf => "600.745.487-86", :last_sign_in_ip => "127.0.0.1", :birthday => '12/09/1976') }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:order) { FactoryGirl.create(:clean_order_credit_card, :user => user, :cart => cart) }
  let(:cart_item) {FactoryGirl.create(:cart_item, :cart => cart)}
  let(:order_analysis_service) {OrderAnalysisService.new(order.payments.first,"0000000000000002", Time.current)}
  context "testing should_send_to_analysis" do
    it "should return false on send_to_analysis" do
      Setting.stub(:send_to_clearsale){false}
      order_analysis_service.should_send_to_analysis?.should eq false
    end

    it "should return true on send_to_analysis" do
      Setting.stub(:send_to_clearsale){true}
      order_analysis_service.should_send_to_analysis?.should eq true
    end
  end

  context "testing send_to_analysis" do
    it "should send the given order for further analysis on clearsale" do
      Clearsale::Analysis.stub(:send_order) {Clearsale::OrderResponse.new(:order_id => order.id, :score => 22.22)}
      Clearsale::OrderResponse.any_instance.stub(:status){:automatic_approval}
      Clearsale::Analysis.should_receive(:send_order)
      order_analysis_service.send_to_analysis
      ClearsaleOrderResponse.all.size.should eq 1
    end
  end

  context "testing check_order" do
    it "should check the given order on clearsale and the order is approved or rejected" do
      Clearsale::OrderResponse.any_instance.stub(:status){:manual_approval}
      Clearsale::Analysis.stub(:get_order_status) {Clearsale::OrderResponse.new(:order_id => order.id, :score => 22.22)}
      Clearsale::Analysis.should_receive(:get_order_status)
      OrderAnalysisService.check_results(order)
      ClearsaleOrderResponse.all.size.should eq 1
    end

    it "should check the given order on clearsale and the order has to be processed" do
      Clearsale::OrderResponse.any_instance.stub(:status){:manual_analysis}
      Clearsale::Analysis.stub(:get_order_status) {Clearsale::OrderResponse.new(:order_id => order.id, :score => 22.22)}
      Clearsale::Analysis.should_receive(:get_order_status)
      OrderAnalysisService.check_results(order)
      ClearsaleOrderResponse.all.should be_empty
    end
  end

end