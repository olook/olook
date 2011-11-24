# -*- encoding: utf-8 -*-
require 'curb'
require 'base64'
require 'openssl'
require 'digest/sha1'

class CloudfrontInvalidator
  attr_reader :aws_account, :aws_secret, :distribution

  def initialize
    rails_root = Rails.root || File.dirname(__FILE__) + '/..'
    rails_env = Rails.env || 'development'

    invalidator_config = YAML.load_file(rails_root + 'config/aws.yml')
    @aws_account = invalidator_config[rails_env]['aws_account']
    @aws_secret = invalidator_config[rails_env]['aws_secret']
    @distribution = invalidator_config[rails_env]['distribution']
  end

  def invalidate(path)
    xml_content = build_xml(path)
    post(xml_content)
  end

  private

  def post(content)
    Curl::Easy.http_post("https://cloudfront.amazonaws.com/2010-08-01/distribution/#{distribution}/invalidation", content) do |c|
      c.headers["Authorization"] = "AWS #{aws_account}:#{build_digest}"
      c.headers["Content-Type"] = 'text/xml'
      c.headers["x-amz-date"] = formatted_date
    end
  end

  def build_digest
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), aws_secret, formatted_date)).strip
  end

  def formatted_date
    Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S %Z")
  end

  def build_xml(path)
    %Q$<InvalidationBatch><Path>#{path}</Path><CallerReference>CLEANING_OLD_IMAGES_#{Time.now.utc.to_i}</CallerReference></InvalidationBatch>$
  end
end

