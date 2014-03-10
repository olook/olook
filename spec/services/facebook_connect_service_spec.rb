require File.expand_path(File.join(__dir__, 'app/service/facebook_connect_service'))

describe FacebookConnectService do
  describe "#connect!" do
    context "when there's not enough data to connect" do
      subject { described_class.new({}) }
      it { expect(subject.connect!).to be_false }
    end

    context "new user" do
      before(:each) do
        subject.stub!(:existing_user).and_return(nil)
      end
      subject { described_class.new({ 'email' => 'teste@teste.com', 'id' => 123 }, { 'accessToken' => 'HEHEHE' }) }

      it "should create an User" do
        subject.should_receive(:create_user).once
        subject.connect!
      end
    end
  end
end
