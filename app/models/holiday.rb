class Holiday < ActiveRecord::Base
  validates :event_date, presence: true
end
