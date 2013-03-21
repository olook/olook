# -*- encoding : utf-8 -*-
module Payments
  module Logger

    def log text
      class_name = self.class == Class ? self.name : self.class.name
      message = "#{Time.now} - #{class_name}"
      message << " - [PaymentID: #{@payment_id}]" if @payment_id
      message << " - #{text}"
      logger.info(message)
    end

    private 
      def logger
        @@logger ||= ::Logger.new("#{Rails.root}/log/braspag-sender.log")
        @@logger
      end
  end

end