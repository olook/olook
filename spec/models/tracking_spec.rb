require "spec_helper"

describe Tracking do
  let(:another_day) { Date.today + 2.days }
  let(:day) { Date.today }

  describe "relationships" do
    it { should belong_to :user }
  end
end