require "spec_helper"

describe Address do
  subject { FactoryGirl.build(:address) }

  context "attributes validation" do
    it { should be_valid }

    it { should validate_presence_of(:number) }
    it { should validate_numericality_of(:number) }

    it "should validate the Zip Format" do
      subject.zip_code = "12345-09"
      subject.should_not be_valid
    end

    it "should validate the telephone format" do
      subject.telephone = "(34)89789236"
      subject.should_not  be_valid
    end

    it "should validate the state format" do
      subject.telephone = "mg"
      subject.should_not  be_valid
    end
  end
end
