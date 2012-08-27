# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BilletMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:line_item) { FactoryGirl.create(:line_item) }
  let(:order) { FactoryGirl.create(:clean_order, :user => user, :line_items => [line_item] )}
  let(:payment) { order.payments.last }

  subject { BilletMailer.send_reminder_mail(payment) }

  describe '#send_reminder_mail' do
    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      subject.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      subject.to.should include(user.email)
    end

    it "should contain users name and billet expiration date in the body" do
      subject.body.should include(user.first_name)
      subject.body.should include(payment.payment_expiration_date.strftime('%d/%m/%Y'))
    end

    context "when not expiring on monday" do
      before do
        payment.payment_expiration_date = Time.new(2012,7,3)
      end

      subject { BilletMailer.send_reminder_mail(payment) }

      it "should contain the word 'Amanhã' if the expiration date is not monday" do
        subject.body.should include('Amanhã')
      end
    end

    context "when expiring on monday" do
      before do
        payment.payment_expiration_date = Time.new(2012,7,2)
      end

      subject { BilletMailer.send_reminder_mail(payment) }

      it "should contain the word 'Segunda-feira'" do
        subject.body.should include('Segunda-feira')
      end
    end

    it 'should return a Mail::Message' do
      subject.should be_instance_of Mail::Message
    end
  end
end
