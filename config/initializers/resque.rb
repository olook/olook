require "resque"
require "resque/failure/multiple"
require "resque/failure/redis"

Resque.redis = YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env]

module Resque
  module Failure
    # Logs failure messages.
    class Logger < Base
      def save
        Rails.logger.error detailed
      end

      def detailed
        <<-EOF
#{worker} failed processing #{queue}:
Payload:
#{payload.inspect.split("\n").map { |l| "  " + l }.join("\n")}
Exception:
  #{exception}
#{exception.backtrace.map { |l| "  " + l }.join("\n")}
        EOF
      end
    end

    # Emails failure messages.
    # Note: uses Mail (default in Rails 3.0) not TMail (Rails 2.x).
    class Notifier < Logger
      def save
        text, subject = detailed, "[Error] #{queue}: #{exception}"
        Mail.deliver do
          from "no-reply@olook.com.br"
          to "stephano.zanzin@codeminer42.com", "rinaldi.fonseca@codeminer42.com", "rafaelrosafu@gmail.com"
          subject subject
          text_part do
            body text
          end
        end
      rescue
        puts $!
      end
    end
  end
end

Resque::Failure::Multiple.configure do |multi|
  # Always stores failure in Redis and writes to log
  multi.classes = Resque::Failure::Redis, Resque::Failure::Logger
  # Production/staging only: also email us a notification
  multi.classes << Resque::Failure::Notifier if Rails.env.production? || Rails.env.staging?
end
