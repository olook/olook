require 'spec_helper'

describe OrderAnalysisService do
  let(:user) { FactoryGirl.create(:user, :email => "teste@teste.com", :cpf => "600.745.487-86", :last_sign_in_ip => "127.0.0.1", :birthday => '12/09/1976') }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) } 
  let(:order) { FactoryGirl.create(:clean_order_credit_card, :user => user, :cart => cart) }
  let(:cart_item) {FactoryGirl.create(:cart_item, :cart => cart)}
  
  context "#should_send_to_analysis?" do

    let!(:current_order) {FactoryGirl.create(:order_without_payment, :user => user )}
    let!(:current_payment) {FactoryGirl.create(:credit_card, :user => user, :order => current_order)}
    let(:service) {OrderAnalysisService.new(current_payment ,"0000000000000009", Time.current) }    

    before do
      Setting.stub(:send_to_clearsale).and_return(true)
      Setting.stub(:force_send_to_clearsale).and_return(false)
    end

    context "configured to skip clearsale" do

      it "should not send to analisys" do
        Setting.stub(:send_to_clearsale).and_return(false)
        service.should_send_to_analysis?.should be_false
      end

      it "should be forced to send to analisys" do
        Setting.stub(:force_send_to_clearsale).and_return(true)
        Setting.stub(:send_to_clearsale).and_return(false)
        service.should_send_to_analysis?.should be_true
      end

      context "but user is blacklisted" do
        before do
          Setting.stub(:as_list).with(:blacklisted_users).and_return(['teste@teste.com'])
        end

        it "send to analysis" do
          service.should_send_to_analysis?.should be_true
        end
      end
    end


    context "user's first buy" do
      it "should have one order" do
        expect(user.orders.count).to eql(1)
      end 

      it "should have one credit card payment" do
        payments = Payment.where("type = 'CreditCard' and user_id = ?", user.id)
        payments.size.should == 1
      end

      it "should send to analysis" do
        service.should_send_to_analysis?.should be_true
      end
    end

    context "user's second buy" do
      before do
        Order.any_instance.stub(:transition_to_authorized)
        @order = FactoryGirl.create(:clean_order_credit_card_authorized, :user => user )
      end
      
      context "with the same credit card" do
        it "should have two orders" do
          expect(user.orders.count).to eql(2)
        end

        it "should have two credit card payment" do
          payments = Payment.where("type = 'CreditCard' and user_id = ?", user.id)
          payments.size.should == 2
        end

        it "should skip analysis" do
          service.should_send_to_analysis?.should be_false
        end
      end

      context "with a different credit card" do

        before do
          @order.payments.first.update_attribute(:credit_card_number, 'XXXXXXXXXXXX7894')
        end

        it " nada " do
          current_payment.credit_card_number.should_not == @order.payments.first.credit_card_number
        end

        it "should send to analysis" do
          service.should_send_to_analysis?.should be_true
        end
      end
    end


  end

  context "testing send_to_analysis" do
    let(:payment) { order.payments.first }
    let(:order_analysis_service) { OrderAnalysisService.new(payment,"0000000000000002", Time.current) }
    
    it "should send the given order for further analysis on clearsale" do
      Setting.stub(:use_clearsale_server) {true}
      Setting.stub(:force_send_to_clearsale) {true}
      Clearsale::Analysis.stub(:send_order) {Clearsale::OrderResponse.new(:order_id => order.id, :score => 22.22)}
      Clearsale::OrderResponse.any_instance.stub(:status){:automatic_approval}
      Clearsale::Analysis.should_receive(:send_order)
      payment.should_receive(:set_state).with(:review).and_return(true)
      payment.should_receive(:save!)

      order_analysis_service.send_to_analysis
      ClearsaleOrderResponse.all.size.should eq 1
    end
  end

  context "testing check_order" do
    it "should check the given order on clearsale and the order is approved or rejected" do
      Setting.stub(:use_clearsale_server) {true}
      Setting.stub(:force_send_to_clearsale) {true}
      Clearsale::OrderResponse.any_instance.stub(:status){:manual_approval}
      Clearsale::Analysis.stub(:get_order_status) {Clearsale::OrderResponse.new(:order_id => order.id, :score => 22.22)}
      Clearsale::Analysis.should_receive(:get_order_status)
      OrderAnalysisService.check_results(order)
      ClearsaleOrderResponse.all.size.should eq 1
    end

    it "should check the given order on clearsale and the order has to be processed" do
      Setting.stub(:use_clearsale_server) {true}
      Setting.stub(:force_send_to_clearsale) {true}
      Clearsale::OrderResponse.any_instance.stub(:status){:manual_analysis}
      Clearsale::Analysis.stub(:get_order_status) {Clearsale::OrderResponse.new(:order_id => order.id, :score => 22.22)}
      Clearsale::Analysis.should_receive(:get_order_status)
      OrderAnalysisService.check_results(order)
      ClearsaleOrderResponse.all.should be_empty
    end
  end

end
