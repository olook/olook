require 'spec_helper'

describe WhatsYourStyle do
  describe "#quiz" do
     use_vcr_cassette "whats_your_style"
    it { expect(subject.quiz).to be_a(Hash) }
  end
end
