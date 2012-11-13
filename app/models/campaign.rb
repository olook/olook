class Campaign < ActiveRecord::Base
  validate :start_at, :presence => true
end
