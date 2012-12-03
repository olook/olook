# == Schema Information
#
# Table name: moip_callbacks
#
#  id               :integer          not null, primary key
#  order_id         :integer
#  id_transacao     :string(255)
#  cod_moip         :string(255)
#  tipo_pagamento   :string(255)
#  status_pagamento :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  classificacao    :string(255)
#  payment_id       :integer
#  processed        :boolean          default(FALSE)
#  retry            :integer          default(0)
#  error            :text
#

require 'spec_helper'

describe MoipCallback do
  context "#update_payment_status" do
    let(:payment) { FactoryGirl.create(:billet) }
    let(:moip_callback) { FactoryGirl.create(:clean_moip_callback) }

    it "should update payment gateway status" do
      moip_callback.update_payment_status(payment)
      payment.reload.gateway_code.to_s.should eq(moip_callback.cod_moip.to_s)
      payment.gateway_type.to_s.should eq(moip_callback.tipo_pagamento.to_s)
      payment.gateway_status.to_s.should eq(moip_callback.status_pagamento.to_s)
      payment.gateway_status_reason.to_s.should eq(moip_callback.classificacao.to_s)
    end

    it "should update payment state" do
      payment.should_receive(:set_state).with(:deliver).and_return(true)
      moip_callback.update_payment_status(payment)
    end

    it "should update moip callback" do
      payment.stub(:set_state).with(:deliver).and_return(true)
      moip_callback.update_payment_status(payment)
      moip_callback.reload.processed.should eq(true)
    end

    context "when order is cancelled" do
      it "should enqueue cancel order" do
        payment.order = mock_model(Order, :canceled? => true, :number => "XPTO")
        payment.order.stub(:reload => payment.order)
        payment.stub(:set_state).and_return(true)
        Resque.should_receive(:enqueue).with(Abacos::CancelOrder, payment.order.number)
        moip_callback.update_payment_status(payment)
      end
    end

    context "when can't update payment" do
      it "should update retry and error in moip callback" do
        #moip_callback.stub(:update_payment_status).and_return(false)
        payment.stub(:set_state).and_return(false)
        payment.errors.stub(:full_messages).and_return(["ERRO XPTO"])
        moip_callback.update_payment_status(payment)
        moip_callback.reload.retry.should eq(1)
        moip_callback.error.should eq("[\"ERRO XPTO\"]")
      end
    end

    context "status" do
      it "should mark as processed when status is invalid" do
        moip_callback.status_pagamento = '0'
        moip_callback.update_payment_status(payment)
        moip_callback.reload.processed.should eq(true)
        moip_callback.error.should eq("Invalid status")
      end
    end

  end
end
