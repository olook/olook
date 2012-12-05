require "spec_helper"

describe SendExpirationDiscountWorker do
  describe ".on perform" do
    context "sending email" do
      let!(:user) { FactoryGirl.create(:user, created_at: DateTime.now - 5.days ) }
      let(:mock_mail) { double :mail }
      it "should send email" do
        mock_mail.should_receive(:deliver)
        ExpirationDiscountMailer.should_receive(:send_expiration_email).once.and_return(mock_mail)
        described_class.perform
      end

      it "shouldn't send email" do
        user.created_at = DateTime.now - 6.days
        user.save
        mock_mail.should_not_receive(:deliver)
        ExpirationDiscountMailer.should_not_receive(:send_expiration_email)
        described_class.perform
      end
    end
  end
end
