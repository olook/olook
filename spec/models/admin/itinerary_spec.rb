 #-*- encoding : utf-8 -*-
 require 'spec_helper'

describe Itinerary do
  context "validations" do
    it {should have_many(:itinerary_entries)}
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
  end
end
