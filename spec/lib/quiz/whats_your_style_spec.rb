require 'spec_helper'

describe Quiz::WhatsYourStyle do
  describe "#quiz" do
    it { expect(subject.quiz).to be_a(JSON) }
  end
end
