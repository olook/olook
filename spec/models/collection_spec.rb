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
end
