require 'spec_helper'

describe GiftOccasion do
  context "validation" do
    it { should belong_to :user }
    # it { should belong_to :gift_recipient }
    it { should belong_to :gift_occasion_type }
    
    it { should validate_presence_of :day }
    it { should validate_presence_of :month }
  end
  
  
  
end
