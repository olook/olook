require 'uri'
require 'logger'
require 'net/http'
require 'digest/sha1'

require 'result'
module Search
  class Retriever
    def initialize(options={})
      @redis = options[:redis]
      @logger = options[:logger] || Logger.new(STDOUT)
    end

    def fetch_result(url, options = {})
      cache_key = Digest::SHA1.hexdigest(url.to_s)
      @logger.error "[cloudsearch] cache_key: #{cache_key}"

      begin
        if @redis && @redis.exists(cache_key)
          cached_response = @redis.get(cache_key)
        else
          @logger.error "[cloudsearch] cache missed"
          url = URI.parse(url)
          tstart = Time.now.to_f * 1000.0
          http_response = Net::HTTP.get_response(url)
          @logger.error("GET cloudsearch URL (time=#{'%0.5fms' % ( (Time.now.to_f*1000.0) - tstart )}): #{url}")
          @logger.error("[cloudsearch] result_code:#{http_response.code}, result_message:#{http_response.message}")
          raise "CloudSearchError" if http_response.code != '200'
          if @redis
            @redis.set(cache_key, http_response.body)
            @redis.expire(cache_key, 30.minutes)
          end
          cached_response =  http_response.body
        end
        Search::Result.new(cached_response, options)
      rescue => e
        @logger.error("[cloudsearch] Error on retrieving url: #{URI.decode url.to_s} with cache_key: #{cache_key}, error: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
        Search::Result.new({:hits => nil, :facets => {} }.to_json, options)
      end
    end
  end
end
