require 'spec_helper'

describe CollectionTheme do
  let(:collection_theme) { FactoryGirl.create(:collection_theme) }
  let(:day_by_day) { FactoryGirl.build(:collection_theme) }

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { collection_theme.should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:slug) }
    it { collection_theme.should validate_uniqueness_of(:slug) }

    it { should validate_numericality_of(:position) }
    it { should have_one(:catalog) }
  end

  describe "default" do
    it { CollectionTheme.new.active.should be_false }
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
