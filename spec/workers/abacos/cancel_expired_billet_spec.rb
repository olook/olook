# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::CancelExpiredBillet do

 #describe ".perform" do

 #  let(:billet_waiting_payment_to_expire) { FactoryGirl.create(:billet, :with_order, :waiting_payment, :to_expire) }
 #  let(:old_billet) { FactoryGirl.create(:billet, :with_order, created_at: 5.business_days.ago) }
 #  let(:waiting_payment_billet) { FactoryGirl.create(:billet, :with_order, :waiting_payment) }

 #  context "billets expired and waiting payment billet" do
 #    subject { billet_waiting_payment_to_expire }
 #    it "sends Abacos to cancel them" do
 #      Abacos::CancelOrder.should_receive(:perform).with(subject.order.number)
 #      described_class.perform
 #    end
 #  end

 #  context "billets expired but already authorized" do
 #    subject { old_billet }
 #    it "doesn't send to Abacos" do
 #      Abacos::CancelOrder.should_not_receive(:perform).with(subject.order.number)
 #      described_class.perform
 #    end
 #  end

 #  context "billets waiting payment but not expired" do
 #    subject { waiting_payment_billet }

 #    it "doesn't send to Abacos" do
 #      Abacos::CancelOrder.should_not_receive(:perform).with(subject.order.number)
 #      described_class.perform
 #    end


 #  end

 #end

end
