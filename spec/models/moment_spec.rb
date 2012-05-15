require 'spec_helper'

describe Moment do
  let(:moment) { FactoryGirl.create(:moment) }
  let(:day_by_day) { FactoryGirl.build(:moment) }
  
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { moment.should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:slug) }
    it { moment.should validate_uniqueness_of(:slug) }
    it { should validate_presence_of(:article) }
    it { should validate_presence_of(:position) }
    it { should have_one(:catalog) }
  end
  
  describe "default" do
    it { Moment.new.active.should be_false }
  end
  
  describe "after create" do
    it "generate catalog" do
      day_by_day.catalog.should be_blank
      day_by_day.save!
      day_by_day.catalog.should_not be_nil
      day_by_day.catalog.should == Catalog::Moment.last
    end
  end
end
