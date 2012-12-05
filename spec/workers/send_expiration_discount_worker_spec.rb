require "spec_helper"

describe SendExpirationDiscountWorker do
  describe ".on perform" do
    let(:user) { FacotyGirl.create(:user, email: "vinicius.monteiro@olook.com.br") }
    let(:mock_mail) { double :mail }
    context "sending email" do
      it "should send email" do
        mock_mail.should_receive(:deliver)
        ExpirationDiscountMailer.should_receive(:send_expiration_email).once.and_return(mock_mail)
        described_class.perform
      end
    end
  end
end
