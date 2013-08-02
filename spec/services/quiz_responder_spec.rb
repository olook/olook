require 'spec_helper'

describe QuizResponder do
  context 'persisting' do
    before do
      @redis = mock(Redis)
      Redis.should_receive(:new).and_return(@redis)
    end

    it "should save on redis" do
      @redis.should_receive(:set).with("qr:123", '{"uuid":123,"profile":"sexy"}')

      @quiz = QuizResponder.new(uuid: 123, profile: 'sexy')
      @quiz.save
    end

    it 'should find on redis' do
      @redis.should_receive(:get).with("qr:123").and_return('{"uuid":123,"profile":"sexy"}')

      @quiz = QuizResponder.find(123)
      expect(@quiz.uuid).to eql(123)
      expect(@quiz.profile).to eql('sexy')
    end

    it 'should destroy on redis' do
      @quiz = QuizResponder.new(uuid: 123, profile: 'sexy')
      @redis.should_receive(:del).with('qr:123')

      @quiz.destroy
    end
  end

  context 'answering' do
    it 'should retrieve profile from WhatsYourStyle::Quiz' do
      ans = {"12"=>"48", "9"=>"34", "7"=>"25", "1"=>"1", "8"=>"30", "19"=>"75", "20"=>"80", "5"=>"17", "13"=>"51", "10"=>"38", "3"=>"12", "11"=>"42"}
      name = 'SUPER DUPPER QUIZ'
      @quiz = QuizResponder.new(name: name, questions: ans)

      @api = mock(WhatsYourStyle::Quiz)
      WhatsYourStyle::Quiz.should_receive(:new).and_return(@api)
      @api.should_receive(:profile_from).with({ name: name, answers: ans }).and_return({uuid: 123, profile: 'sexy'})

      @quiz.retrieve_profile
      expect(@quiz.profile).to eq('sexy')
      expect(@quiz.uuid).to eq(123)
    end
  end

  describe '#update_profile' do
    let(:user) { FactoryGirl.create(:user) }

    it "updates user's profile" do
      user.should_receive(:update_attributes)
      subject.update_profile(user)
    end
  end

  context 'next step' do
    # BIG LOGIC HERE
  end
end
