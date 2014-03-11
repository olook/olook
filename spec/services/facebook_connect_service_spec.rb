require File.expand_path(File.join(__dir__, '../../app/services/facebook_connect_service'))
# require File.expand_path(File.join(File.dirname(__FILE__), '../../app/services/cart_discount_service'))

describe FacebookConnectService do
  describe "#get_facebook_data" do

  end

  describe "#connect!" do
    before(:each) do
      subject.stub(:valid_facebook_data?).and_return(true)
    end
    context "when there's not enough data to connect" do
      subject { described_class.new({}) }
      it { expect(subject.connect!).to be_false }
    end

    context "new user" do
      before(:each) do
        subject.stub!(:existing_user).and_return(nil)
      end
      subject { described_class.new({ 'accessToken' => 'HEHEHE' }) }

      it "should create an User" do
        subject.should_receive(:create_user).once
        subject.connect!
      end

      it "should set user" do
        user = double('user')
        subject.stub(:create_user).and_return(user)
        expect(subject.user).to be_eql(user)
      end
    end

    context "existing user" do
      before(:each) do
        @user = double('user')
        subject.stub!(:existing_user).and_return(@user)
      end
      subject { described_class.new({ 'email' => 'teste@teste.com', 'id' => 123 }, { 'accessToken' => 'HEHEHE' }) }

      it "should create an User" do
        subject.should_not_receive(:create_user)
        subject.should_receive(:update_user)
        subject.connect!
      end

      it "should set user" do
        subject.stub(:create_user).and_return(user)
        expect(subject.user).to be_eql(user)
      end
    end
  end
end
