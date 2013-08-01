require 'spec_helper'

describe WhatsYourStyle::Quiz do
  describe "#questions" do
    use_vcr_cassette 'whats_your_style'
    it { expect(subject.questions).to be_a(Hash) }
  end
end
