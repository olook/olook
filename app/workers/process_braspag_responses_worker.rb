# -*- encoding : utf-8 -*-
class ProcessBraspagResponsesWorker
  @queue = :order_status

  def self.perform
    process_authorize_responses
    process_capture_responses
  end

  def self.process_authorize_responses
    BraspagAuthorizeResponse.to_process.find_each do |authorize_response|
    end
  end

  def self.process_capture_responses
    CaptureResponse.to_process.find_each do |capture_response|
    end
  end

end