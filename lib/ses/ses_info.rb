# -*- encoding : utf-8 -*-
module Ses
  class SesInfo
    def initialize
      file_dir = "#{Rails.root}/config/aws.yml"
      @access_key = YAML::load(File.open(file_dir))[Rails.env]["aws_secret"]
      @secret_access = YAML::load(File.open(file_dir))[Rails.env]["aws_account"]
    end

    def save_ses_info
      SimpleEmailServiceInfo.create(retreive_ses_info.merge!(sent: yesterday) )
    end

    def retreive_ses_info
      aws_ses_model = AWS::SimpleEmailService.new(:access_key_id => @secret_access , :secret_access_key => @access_key)
      hash = aws_ses_model.statistics.select{|stats| day_range.cover?(stats[:sent]) }
      Hash[ [:bounces,:complaints,:delivery_attempts,:rejects].map{ |k| [k, hash.inject(0){|sum, info| sum + info[k]}] } ]
    end

    def day_range
      (yesterday.beginning_of_day)..(yesterday.end_of_day)
    end

    def yesterday
      (Time.zone.now - 1.day)
    end
  end
end
