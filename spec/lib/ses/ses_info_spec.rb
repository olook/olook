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

  describe "#retreive_ses_info", vcr: true do
    it "returns hash" do
      expect(subject.retreive_ses_info).to be_an_instance_of Hash
    end

    it "have correctly keys" do
      ses_hash = subject.retreive_ses_info
      expect(ses_hash).to have_key(:bounces)
      expect(ses_hash).to have_key(:complaints)
      expect(ses_hash).to have_key(:delivery_attempts)
      expect(ses_hash).to have_key(:rejects)
    end
  end
end
