require 'spec_helper'

describe WhatsYourStyle::Question do
  let(:answers) { [{ id: 1, image: 'foo', text: 'bar' }, { id: 1, image: 'foo', text: 'bar' }] }
  describe '#initialize' do

    it "creates new answers" do
      WhatsYourStyle::Answer.should_receive(:new).twice
      described_class.new(answers)
    end

    describe '#answers' do
      subject { described_class.new(answers) }

      it { expect(subject.answers).to be_a(Array) }
      it { expect(subject.answers.count).to eq(2) }
    end
  end
end
