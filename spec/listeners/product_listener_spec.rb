# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductListener do

  describe "#notify_about_visibility" do
    let(:admin) { FactoryGirl.build(:admin) }
    let(:products_id) { [1,2,3] }
    let(:mock_mail) { double :mail }


    context "when environment is production" do
      before do
        Rails.env.stub(:production?).and_return(true)
      end
      it "sends email about notification" do
        DevAlertMailer.should_receive(:product_visibility_notification).and_return(mock_mail)
        mock_mail.should_receive(:deliver)
        described_class.notify_about_visibility(products_id, admin)
      end
    end

    context "when environment is not production" do
      it "doesn't send email about notification" do
        DevAlertMailer.should_not_receive(:product_visibility_notification)
        mock_mail.should_not_receive(:deliver)
        described_class.notify_about_visibility(products_id, admin)
      end
    end


  end

end
