Rails.configuration.log_tags = [
  :remote_ip
]

#
# MonkeyPatch to remove the view logging
#
module ActionView
  class LogSubscriber < ActiveSupport::LogSubscriber
    def logger
      Logger.new('/dev/null')
    end
  end
end