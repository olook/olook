require 'spec_helper'

describe WhatsYourStyle::Quiz do
  describe "#questions" do
    use_vcr_cassette 'whats_your_style'
    subject { described_class.new.questions }
    it { should be_a(Array) }
    it { expect(subject.first.answers).to_not be_nil }

    it "creates questions" do
      WhatsYourStyle::Question.should_receive(:new).exactly(12).times
      described_class.new.questions
    end

  end
end
