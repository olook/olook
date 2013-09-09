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
end
