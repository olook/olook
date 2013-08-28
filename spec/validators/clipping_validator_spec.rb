require 'spec_helper'

describe ClippingValidator do
  describe '#validate' do
    subject { described_class.new({}) }
    context "when link" do
      let(:clipping) { FactoryGirl.build(:clipping, :with_link) }
      it "doesn't return error message" do
        clipping.errors.should_not_receive(:add).with(:base, 'por favor adicione um link ou um arquivo pdf')
        subject.validate(clipping)
      end
    end

    context "with pdf" do
      let(:clipping) { FactoryGirl.build(:clipping, :with_pdf) }
      it "doesn't return error message" do
        clipping.errors.should_not_receive(:add).with(:base, 'por favor adicione um link ou um arquivo pdf')
        subject.validate(clipping)
      end
    end

    context "without link and pdf" do
      let(:clipping) { FactoryGirl.build(:clipping) }
      it "returns error message" do
        clipping.errors.should_receive(:add).with(:base, 'por favor adicione um link ou um arquivo pdf')
        subject.validate(clipping)
      end
    end
  end
end
