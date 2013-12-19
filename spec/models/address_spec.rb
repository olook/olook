require "spec_helper"

describe Address do
  subject { FactoryGirl.build(:address) }

  context "attributes validation" do
    it { should be_valid }

    it { should validate_presence_of(:number) }
    it { should validate_numericality_of(:number) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:neighborhood) }

    it "should require telephone if there is no mobile" do
      subject.mobile = nil
      subject.telephone = "(11)3856-8987"
      # subject.save!
      subject.should be_valid
    end

    it "should require at least one telephone" do
      subject.should_receive(:require_telephone).and_return(true)
      subject.mobile = nil
      subject.telephone = nil
      subject.should_not be_valid
    end

    it "should validate the Zip Format" do
      subject.zip_code = "12345-09"
      subject.should_not be_valid
    end

    it "should validate the state format" do
      subject.state = "MG"
      subject.should be_valid
    end

    it "should validate the state format and not be valid" do
      subject.state = "mg"
      subject.should_not be_valid
    end

    describe "Mobile number format" do
      it "(31)98978-9236 should be valid" do
        subject.mobile = "(31)98978-9236"
        subject.should be_valid
      end

      it "(11)98978923 should not be valid" do
        subject.mobile = "(11)98978923"
        subject.should_not be_valid
      end

      it "(31)9897-8923 should be valid" do
        subject.mobile = "(31)9897-8923"
        subject.should be_valid
      end

      it "(11)989789236 should not be valid" do
        subject.mobile = "(11)989789236"
        subject.should_not be_valid
      end
    end

    describe "Telephone number format" do
      it "(11)5978-9236 should be valid" do
        subject.telephone = "(11)5978-9236"
        subject.should be_valid
      end

      it "(31)9897-8923 should be valid" do
        subject.telephone = "(31)9897-8923"
        subject.should be_valid
      end

      it "(21)98988631 should not be valid" do
        subject.telephone = "(21)98988631"
        subject.should_not be_valid
      end

      it "(11)98978-9236 should be valid" do
        subject.mobile = "(11)98978-9236"
        subject.should be_valid
      end

      it "(11)98978923 should not be valid" do
        subject.mobile = "(11)98978923"
        subject.should_not be_valid
      end

      it "(11)989789236 should not be valid" do
        subject.mobile = "(11)989789236"
        subject.should_not be_valid
      end

    end

  end

  describe "#identification" do
    it "should return the first name + the last name" do
      FactoryGirl.build(:address, :first_name => "My", :last_name => "Home").identification.should eql("My Home")
    end
  end

  describe "normalize street" do
    it "should dont change the value of street when is greated one character" do
      address = Address.new(:street => "ab")
      address.valid?
      address.street.should eq("ab")
    end

    it "should add suffix in the value of street when is one character" do
      address = Address.new(:street => "a")
      address.valid?
      address.street.should eq("Rua a")
    end
  end
end
