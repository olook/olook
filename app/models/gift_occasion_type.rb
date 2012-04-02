class GiftOccasionType < ActiveRecord::Base
  validates :name, :presence => true
end
