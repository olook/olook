require 'spec_helper'

describe QuizResponder do
  context 'persisting' do
    before do
      @redis = mock
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

    end
  end
end
