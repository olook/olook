require 'spec_helper'

describe Quiz::Answer do

  describe "#initialize" do
    let(:parameters) { { id: 1, image: 'foo', text: 'bar' } }

    subject { described_class.new(parameters) }

    it { expect(subject.id). to eq(parameters[:id]) }
    it { expect(subject.image). to eq(parameters[:image]) }
    it { expect(subject.text). to eq(parameters[:text]) }

    context "when there's any given params that has no setter" do
      let(:parameters) { { id: 1, image: 'foo', text: 'bar', other_param: 'value' } }

      subject { described_class.new(parameters) }

      it { expect(subject.id). to eq(parameters[:id]) }
      it { expect(subject.image). to eq(parameters[:image]) }
      it { expect(subject.text). to eq(parameters[:text]) }
    end

  end
end
