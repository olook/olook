# -*- encoding : utf-8 -*-
require 'spec_helper'

describe IntegrationProductsAlert do
  describe '.notify' do
    let(:email) { "francisco@buarque.com.br" }
    let(:products_amount) { 10 }
    let(:errors) { {  } }
    let(:mail) { double :mail }

    it "creates email" do
      mail.stub(:deliver)
      described_class.any_instance.should_receive(:mail).with({ to: email, subject: "Sincronização de produtos concluída"}).and_return(mail)
      described_class.notify(email, products_amount, errors)
    end

    it "deliveries email" do
      described_class.any_instance.stub(:mail).and_return(mail)
      mail.should_receive(:deliver)
      described_class.notify(email, products_amount, errors)
    end
  end
end
