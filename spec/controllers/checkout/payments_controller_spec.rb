# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::PaymentsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:payment) { order.erp_payment }
  let(:total) { 99.55 }
  let(:waiting_payment) { "3" }
  let(:cod_moip) { "3" }
  let(:tipo_pagamento) { "CartaoDeCredito" }
  let(:classificacao) { "TUDO CERTO" }
  let(:params) {{:status_pagamento => waiting_payment, :id_transacao => payment.identification_code, :value => total, :cod_moip => cod_moip, :tipo_pagamento => tipo_pagamento, :classificacao => classificacao}}
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }

  before :each do

    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
    Airbrake.stub(:notify)
    FactoryGirl.create(:line_item, :order => Order.find(order))
  end

  context "POST create" do
    context "with valids params" do
      it "should return 200" do
        post :create, params
        response.status.should == 200
      end

      xit "should change the payment status to waiting_payment" do
        post :create, params
        payment.reload.waiting_payment?.should eq(true)
      end

      it "should update payment with the params" do
        post :create, params
        payment.reload.gateway_code.should == cod_moip
        payment.reload.gateway_status.to_s.should == waiting_payment
        payment.reload.gateway_type.should == tipo_pagamento
        payment.reload.gateway_status_reason.should == classificacao
      end

      xit "should change the order status to authorized" do
        waiting_payment = "3"
        post :create, :status_pagamento => waiting_payment, :id_transacao => payment.identification_code, :value => total
        authorized = "1"
        post :create, :status_pagamento => authorized, :id_transacao => payment.identification_code, :value => total
        order.reload.authorized?.should eq(true)
      end

      xit "should change not the order status after receiving completed" do
        waiting_payment = "3"
        post :create, :status_pagamento => waiting_payment, :id_transacao => payment.identification_code, :value => total
        authorized = "1"
        post :create, :status_pagamento => authorized, :id_transacao => payment.identification_code, :value => total
        completed = "4"
        post :create, :status_pagamento => completed, :id_transacao => payment.identification_code, :value => total
        order.reload.authorized?.should eq(true)
      end

      it "should create a MoipCallback" do
        expect {
        post :create, :status_pagamento => waiting_payment,
                      :id_transacao => payment.identification_code, :tipo_pagamento => tipo_pagamento, :cod_moip => cod_moip
        }.to change(MoipCallback, :count).by(1)
      end

    end

    context "with invalids params" do
      xit "should return 500 with a invalid status" do
        invalid_status = "0"
        post :create, :status_pagamento => invalid_status, :id_transacao => payment.identification_code, :value => total
        response.status.should == 500
      end
    end
  end
end
