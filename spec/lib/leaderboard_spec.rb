require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/leaderboard'))
require 'redis'

describe Leaderboard do
  after do
    Leaderboard.clear
  end
  context "in case of error" do
    it "should not raise an error" do
      expect {
        described_class.new(key: 'sapato:anabela', redis: nil).score(1)
      }.to_not raise_error
    end
  end

  context "with just one item" do
    subject { described_class.new(key: 'sapato:anabela', redis: Redis.new) }
    before do
      subject.score(1199)
    end
    it "should return just these item with full key" do
      expect(subject.rank(5)).to eq(['1199'])
    end

    it "should return just these item with half key" do
      subject { described_class.new(key: 'sapato', redis: Redis.new) }
      expect(subject.rank(5)).to eq(['1199'])
    end
  end

  context "with two items" do
    subject { described_class.new(key: 'sapato:anabela', redis: Redis.new) }
    before do
      2.times { subject.score(1199) }
      subject.score(1198)
    end
    it "should return just these item with full key" do
      expect(subject.rank(5)).to eq(['1199', '1198'])
    end

    it "should return just these item with half key" do
      subject { described_class.new(key: 'sapato', redis: Redis.new) }
      expect(subject.rank(5)).to eq(['1199', '1198'])
    end

    it "should invert sequence when the second id has more scores than first" do
      7.times { subject.score(1198) }
      expect(subject.rank(5)).to eq(['1198', '1199'])
    end
  end
end
