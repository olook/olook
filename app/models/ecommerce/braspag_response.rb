class BraspagResponse < ActiveRecord::Base
  scope :authorize_response, where("type = ?", "authorize_response")
  scope :capture_response, where("type = ?", "capture_response")
end
