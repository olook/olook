# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Collection do
  subject { FactoryGirl.create :collection }

  describe 'validations' do
    it { should have_many(:products) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end

  describe '#for_date' do
    before :each do
      subject # make sure the test collection is created
    end

    it 'should return the collection active for the informed date' do
      described_class.for_date(Date.civil( 2011, 12, 10 )).should == subject
    end
    it "should return nil if there's no active collection for the informed date" do
      described_class.for_date(Date.civil( 2010, 12, 10 )).should be_nil
    end
  end

  it "#current" do
    Date.stub(:today).and_return(:today)
    described_class.should_receive(:for_date).with(:today)
    described_class.current
  end

  it "#from_the_last_month" do
    current_collection = FactoryGirl.create :collection, :is_active => false
    last_collection    = FactoryGirl.create :collection, :start_date => 1.month.ago, :end_date => 1.month.ago + 20.days
    described_class.from_last_month.should == last_collection
  end
end
