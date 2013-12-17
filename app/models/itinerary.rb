class Itinerary < ActiveRecord::Base
  attr_accessible :description, :name, :itinerary_entries_attributes
  has_many :itinerary_entries
  accepts_nested_attributes_for :itinerary_entries, allow_destroy: true

  validates_presence_of :name, :description

  def self.entries
    first.itinerary_entries
  end

  def self.olookmovel
    find_by_name('olookmovel')
  end
end