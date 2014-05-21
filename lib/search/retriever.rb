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
      response = cache(cache_key(url), 30*60) do
        %r{http://(?<host>[^/]+)(?<resource>/.*)} =~ url
        http_response = log_time("GET cloudsearch URL (time=%0.5fms)", url) do
          Net::HTTP.get_response(host, resource)
        end
        @logger.debug("[cloudsearch] result_code:#{http_response.code}, result_message:#{http_response.message}")
        raise "CloudSearchError" if http_response.code != '200'
        http_response.body
      end
      Search::Result.factory.new(response, options)
    rescue => e
      @logger.error("[cloudsearch] Error on retrieving url: #{url} with cache_key: #{cache_key(url)}, error: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
      Search::Result.factory.new({:hits => nil, :facets => {} }.to_json, options)
    end

    private

    def log_time(msg, url=nil)
      tstart = Time.now.to_f * 1000.0
      result = yield
      @logger.debug(sprintf(msg, ( (Time.now.to_f*1000.0) - tstart ).to_f ) + " #{url}")
      result
    end

    def cache(_cache_key, expire)
      cached = nil
      if @redis && @redis.exists(_cache_key)
        @logger.debug "[cloudsearch] cache hit"
        cached = @redis.get(_cache_key) rescue nil
      end
      return cached if cached
      @logger.debug "[cloudsearch] cache missed"
      cached = yield
      if @redis
        @redis.set(_cache_key, cached)
        @redis.expire(_cache_key, expire)
      end
      cached
    end

    def cache_key(url)
      return @cache_key if @cache_key
      @cache_key = Digest::SHA1.hexdigest(url.to_s)
      @logger.debug "[cloudsearch] cache_key: #{@cache_key}"
      @cache_key
    end
  end
end
