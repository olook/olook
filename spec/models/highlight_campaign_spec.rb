require 'spec_helper'

describe HighlightCampaign do
  describe "Validations" do
    it { should validate_presence_of(:label) }
  end
end
