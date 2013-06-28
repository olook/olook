require 'spec_helper'

describe HighlightCampaign do
  describe "Validations" do
    it { should validate_presence_of(:label) }
  end
  describe "Acossiations" do
    it { should have_and_belong_to_many(:products) }
  end
end
