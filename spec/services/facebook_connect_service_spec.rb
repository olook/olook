require File.expand_path(File.join(__dir__, '../../app/services/facebook_connect_service'))

describe FacebookConnectService do
  describe "#get_facebook_data" do
    before(:each) do
      @access_token = 'HEHEHE'
    end
    subject { described_class.new({'accessToken' => @access_token}) }
    it "should call fb_api with '/me' and @access_token" do
      subject.should_receive(:fb_api).with('/me', @access_token)
      subject.get_facebook_data
    end
  end

  describe "#connect!" do
    before(:each) do
      subject.stub(:get_facebook_data).and_return({"id" => '123', 'email' => 'teste@teste.com'})
    end

    subject { described_class.new({ 'accessToken' => 'HEHEHE' }) }

    context "when facebook data has error" do
      before(:each) do
        subject.stub(:get_facebook_data).and_return({"error"=>{"message"=>"The access token could not be decrypted", "type"=>"OAuthException", "code"=>190}})
      end
      it { expect(subject.connect!).to be_false }
    end

    context "new user" do
      before(:each) do
        subject.stub!(:existing_user).and_return(false)
      end

      it "should create an User" do
        subject.should_receive(:create_user).once
        subject.connect!
      end

      it "should set user" do
        @user = double('user')
        subject.stub!(:create_user).and_return(@user)
        subject.connect!
        expect(subject.user).to eq(@user)
      end
    end

    context "existing user" do
      before(:each) do
        @user = double('user')
        subject.stub!(:existing_user).and_return(@user)
      end

      it "should update an User" do
        subject.should_not_receive(:create_user)
        subject.should_receive(:update_user)
        subject.connect!
      end

      it "should set user" do
        subject.stub(:update_user).and_return(@user)
        subject.connect!
        expect(subject.user).to eq(@user)
      end
    end
  end
end
