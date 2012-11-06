# -*- encoding : utf-8 -*-
class ProcessBraspagResponsesWorker
  @queue = :order_status

  def self.perform
    process_authorize_responses
    process_capture_responses
  end

  def self.process_authorize_responses
    BraspagAuthorizeResponse.to_process.find_each do |authorize_response|
      process_braspag_response(authorize_response)
    end
  end

  def self.process_capture_responses
    BraspagCaptureResponse.to_process.find_each do |capture_response|
      process_braspag_response(capture_response)
    end
  end

  private

  def self.process_braspag_response(braspag_response)
    puts braspag_response.inspect
    payment = Payment.find_by_identification_code(braspag_response.order_id)
    if payment
      braspag_response.update_payment_status(payment)
    else
      braspag_response.update_attributes(
        processed: true,
        error_message: "Pagamento não identificado."
      )
    end
  end

end