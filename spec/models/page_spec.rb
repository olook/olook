require 'spec_helper'

describe Page do

  context "validations" do 
    it { should have_many :campaign_pages }
    it { should have_many(:campaigns).through(:campaign_pages) }
  end

end
