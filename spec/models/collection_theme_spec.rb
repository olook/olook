require 'spec_helper'

describe CollectionTheme do
  let(:collection_theme) { FactoryGirl.create(:collection_theme) }
  let(:day_by_day) { FactoryGirl.build(:collection_theme) }

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { collection_theme.should validate_uniqueness_of(:slug) }
    it { should have_one(:catalog) }
  end

  describe "association" do
    it { should have_and_belong_to_many(:products) }
  end

  describe "default" do
    it { CollectionTheme.new.active.should be_false }
    it { expect(CollectionTheme.new(name: 'Super teste').slug).to eql('super-teste') }
  end

  describe "after create" do
    it "generate catalog" do
      day_by_day.catalog.should be_blank
      day_by_day.save!
      day_by_day.catalog.should_not be_nil
      day_by_day.catalog.should == Catalog::CollectionTheme.last
    end
  end

  describe '#video_id' do
    context 'when video_link nil' do
      subject { CollectionTheme.new(video_link: nil).video_id }
      it { should == nil }
    end

    context 'when video_link filled' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/watch?v=1tCr23eZ7Vo&list=UUjPbOLQD7X5ef0T29IkkXzQ').video_id }
      it { should == '1tCr23eZ7Vo' }
    end

    context 'when video_link filled with embed link' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/embed/1tCr23eZ7Vo?list=UUjPbOLQD7X5ef0T29IkkXzQ').video_id }
      it { should == '1tCr23eZ7Vo' }
    end
  end

  describe '#video_options' do
    context 'when video_link nil' do
      subject { CollectionTheme.new(video_link: nil).video_options }
      it { should == { } }
    end

    context 'when video_link filled' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/watch?v=1tCr23eZ7Vo&list=UUjPbOLQD7X5ef0T29IkkXzQ').video_options }
      it { should == { 'list' => 'UUjPbOLQD7X5ef0T29IkkXzQ' } }
    end

    context 'when video_link filled with embed link' do
      subject { CollectionTheme.new(video_link: 'http://www.youtube.com/embed/1tCr23eZ7Vo?list=UUjPbOLQD7X5ef0T29IkkXzQ').video_options }
      it { should == { 'list' => 'UUjPbOLQD7X5ef0T29IkkXzQ' } }
    end
  end
end
