require 'spec_helper'

describe WhatsYourStyle::Quiz do
  use_vcr_cassette 'whats_your_style', record: :new_episodes
  describe "#questions" do
    subject { described_class.new.questions }
    it { should be_a(Array) }
    it { expect(subject.first).to respond_to(:answers) }
    it { expect(subject.first.answers).to_not be_nil }

    it "creates questions" do
      WhatsYourStyle::Question.should_receive(:new).exactly(12).times
      described_class.new.questions
    end
  end

  describe "#name" do
    it { expect(subject.name).to eql("Whats your style?") }
  end

  describe "#profile_from" do
    it { expect{subject.profile_from}.to raise_error(ArgumentError) }

    it "should have a profile and uuid" do
      hash = {"cool quiz" => {"1" => "3", "2" => "3"}}
      subject.profile_from(hash)

    end
  end

end
