require 'spec_helper'

describe CampaignPage do

  context "validations" do 
    it { should validate_presence_of :campaign_id }
    it { should validate_presence_of :page_id }
  end

end
