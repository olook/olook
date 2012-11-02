class BraspagResponse < ActiveRecord::Base
  scope :authorize_response, where("type = ?", "authorize_response")
  scope :capture_response, where("type = ?", "capture_response")
  attr_accessor :correlation_id, :success, :error_code, :error_message, :processed
end
