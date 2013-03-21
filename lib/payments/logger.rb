# -*- encoding : utf-8 -*-
module Payments
  module Logger

    def log text
      logger.info("#{Time.now} - [#{@payment_id}] - #{text}")
    end

    private 
      def logger
        @@logger ||= ::Logger.new("#{Rails.root}/log/braspag-sender.log")
        @@logger
      end
  end

end