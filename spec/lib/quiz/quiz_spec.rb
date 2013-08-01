require 'spec_helper'

describe Quiz do
  describe "#questions" do
    it { expect(subject.quiz).to be_a(Hash) }
  end
end
