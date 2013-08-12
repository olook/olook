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
      @api.stub(:logger=)
      WhatsYourStyle::Quiz.should_receive(:new).and_return(@api)
      @api.should_receive(:profile_from).with({ name: name, answers: ans }).and_return({uuid: 123, profile: 'sexy'})

      expect(@quiz.retrieve_profile).to eql(@quiz)
      expect(@quiz.profile).to eq('sexy')
      expect(@quiz.uuid).to eq(123)
    end
  end

  describe '#update_profile' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:profile, alternative_name: 'sexy')
    end

    it "updates user's profile" do
      QuizResponder.new(user: user, profile: 'sexy', uuid: '123123123').update_profile
      expect(user.profiles).to eql([Profile.for_wysprofile('sexy').first])
    end
  end

  context 'validate!' do
    include Rails.application.routes.url_helpers
    before do
      QuizResponder.any_instance.stub(:save)
    end
    it 'should return self' do
      @qr = QuizResponder.new(name: 'Whiskas', user: FactoryGirl.build(:user))
      expect(@qr.validate!).to eql(@qr)
    end

    context 'only without questions' do
      before do
        subject.validate!
      end

      subject { QuizResponder.new(user: FactoryGirl.build(:user)) }
      it { expect(subject.next_step).to eql(wysquiz_path) }
    end

    context 'with uuid and profile' do
      subject { QuizResponder.new(uuid: 111, profile: 'sexy') }
      it {
        subject.validate!
        expect(subject.next_step).to eql(join_path(uuid: 111))
      }
    end

    context 'only without name' do
      before do
        subject.validate!
      end

      subject { QuizResponder.new(questions: { '1' => '2' }, user: FactoryGirl.build(:user)) }
      it { expect(subject.next_step).to eql(wysquiz_path) }
    end

    context 'retrieving profile' do
      before do
        @api = mock(WhatsYourStyle)
        subject.stub(:api).and_return(@api)
        @api.stub(:profile_from).and_return({uuid: '123', profile: 'sexy'})
      end

      context 'only without user' do
        subject { QuizResponder.new(questions: { '1' => '2' }, name: 'Whiskas') }
        it {
          subject.validate!
          expect(subject.next_step).to eql(join_path(uuid: subject.uuid))
        }

        context 'with @profile and @uuid' do
          it {
            subject.profile = 'sexy'
            subject.uuid = 123
            subject.should_not_receive(:retrieve_profile)
            subject.validate!
          }
        end

        context 'persisting' do
          it {
            subject.should_receive(:save)
            subject.validate!
          }
        end
      end

      context 'has questions, name and user' do
        subject { QuizResponder.new(uuid: '123', profile: 'sexy', user: FactoryGirl.create(:user)) }
        before do
          FactoryGirl.create(:profile, alternative_name: 'sexy')
          subject.stub!(:destroy)
        end
        it "should indicate /voce" do
          subject.validate!
          expect(subject.next_step).to eql(profile_path(f: '1'))
        end

        it 'should destroy eventually saved state' do
          subject.should_receive(:destroy)
          subject.validate!
        end

        it 'should set user.main_profile' do
          subject.validate!
          expect(subject.user.main_profile).to eql(Profile.for_wysprofile('sexy').first)
        end
      end
    end
  end
end
