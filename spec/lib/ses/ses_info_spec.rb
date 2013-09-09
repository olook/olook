require 'spec_helper'

describe Ses::SesInfo do
  describe "#initialize" do
    it "have aws access key" do
      expect(subject.instance_variable_get("@access_key")).to_not be_blank
    end
    it "have aws access secret" do
      expect(subject.instance_variable_get("@secret_access")).to_not be_blank
    end
  end

  describe "#retreive_ses_info", :vcr do
    use_vcr_cassette
    it "returns hash" do
      expect(subject.retreive_ses_info).to be_an_instance_of Hash
    end

    it "have bounces key" do
      expect(subject.retreive_ses_info).to have_key(:bounces)
    end
  end
end
