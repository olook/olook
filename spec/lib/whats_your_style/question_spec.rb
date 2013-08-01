require 'spec_helper'

describe WhatsYourStyle::Question do
  let(:parameters) { { id: 1, text: 'bar' } }
  let(:answers) { [{ id: 1, image: 'foo', text: 'bar' }, { id: 1, image: 'foo', text: 'bar' }] }
  describe '#initialize' do

    subject { described_class.new(parameters, answers) }

    it { expect(subject.id). to eq(parameters[:id]) }
    it { expect(subject.text). to eq(parameters[:text]) }

    it "creates new answers" do
      WhatsYourStyle::Answer.should_receive(:new).twice
      described_class.new(parameters, answers)
    end

    describe '#answers' do
      subject { described_class.new(parameters, answers) }

      it { expect(subject.answers).to be_a(Array) }
      it { expect(subject.answers.count).to eq(2) }
    end
  end
end
