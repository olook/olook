require 'openssl'
require 'digest/sha1'
require 'base64'
require 'curb'

class CloudfrontInvalidator

  def initialize
    rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/..'
    rails_env = ENV['RAILS_ENV'] || 'development'

    invalidator_config = YAML.load_file(rails_root + '/config/aws.yml')
    @aws_account = invalidator_config[rails_env]['aws_account']
    @aws_secret = invalidator_config[rails_env]['aws_secret']
    @distribution = invalidator_config[rails_env]['distribution']
  end

  def invalidate(path)
    date = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S %Z")
    digest = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), @aws_secret, date)).strip

    request = %Q$<InvalidationBatch><Path>#{path}</Path><CallerReference>CLEANING_OLD_IMAGES_#{Time.now.utc.to_i}</CallerReference></InvalidationBatch>$

    Curl::Easy.http_post("https://cloudfront.amazonaws.com/2010-08-01/distribution/#{@distribution}/invalidation", request) do |c|
      c.headers["Authorization"] = "AWS #{@aws_account}:#{digest}"
      c.headers["Content-Type"] = "text/xml"
      c.headers["x-amz-date"] = date
    end
  end
end
