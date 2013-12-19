class ItineraryEntry < ActiveRecord::Base
  attr_accessible :itinerary_id, :when_date, :where
  belongs_to :itinerary

  validates_presence_of :when_date, :where
end
