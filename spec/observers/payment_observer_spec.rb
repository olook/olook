describe 'spec_helper'

describe PaymentObserver do
  describe '.notify_about_authorization' do
    let(:order) { FactoryGirl.build(:order) }
    before do
      payment.stub(:order).and_return(order)
    end
    context "when is a billet" do
      let(:payment) { FactoryGirl.build(:billet, :waiting_payment) }
      it "enqueues an email to notify about authorization" do
        DevAlertMailer.should_receive(:notify).with(to: 'rafael.manoel@olook.com.br', subject: "Ordem de numero #{ payment.order.number } foi autorizada")
        described_class.notify_about_authorization(payment)
      end
    end
  end
end
