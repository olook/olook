require 'spec_helper'

describe CollectionThemeGroup do
  context "On creation" do
    it "be invalid with name" do
      expect(CollectionThemeGroup.new).to_not be_valid
    end
  end
end
