require 'spec_helper'

describe ItineraryEntry do
  context "validations" do
    it {should validate_presence_of(:when_date)}
    it {should validate_presence_of(:where)}
    it {should belong_to(:itinerary)}
  end
end
