require 'spec_helper'

describe Quiz do
  describe "#questions" do
    it { expect(subject.questions).to be_a(Hash) }
  end
end
