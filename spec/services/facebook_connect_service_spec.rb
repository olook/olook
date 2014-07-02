require File.expand_path(File.join(__dir__, '../../app/services/facebook_connect_service'))

describe FacebookConnectService do
  describe "#get_facebook_data" do
    before(:each) do
      @access_token = 'HEHEHE'
      subject.stub(:facebook_config).and_return({'app_id' => '123', 'app_secret' => '123abc'})
      subject.stub(:send_event)
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
      subject.stub(:facebook_config).and_return({'app_id' => '123', 'app_secret' => '123abc'})
      subject.stub(:send_event)
      subject.stub(:get_facebook_likes).and_return([])
      subject.stub(:logger).and_return(mock(info: '', debug: '', error: '', warn: ''))
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
        subject.should_receive(:extend_fb_token)
        subject.connect!
      end

      it "should set user" do
        @user = double('user')
        subject.stub!(:create_user).and_return(@user)
        subject.should_receive(:extend_fb_token)
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
        subject.should_receive(:extend_fb_token)
        subject.connect!
      end

      it "should set user" do
        subject.stub(:update_user).and_return(@user)
        subject.should_receive(:extend_fb_token)
        subject.connect!
        expect(subject.user).to eq(@user)
      end
    end
  end
end
