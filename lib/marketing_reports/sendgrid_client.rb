# -*- encoding : utf-8 -*-

module MarketingReports
  class SendgridClient

    BASE_URL = "https://sendgrid.com/api"
    API_USER = "olook"
    API_KEY = "olook123abc"
    SERVICES = {
                 :invalid_emails => "invalidemails.get.xml",
                 :spam_reports => "spamreports.get.xml",
                 :unsubscribes => "unsubscribes.get.xml",
                 :blocks => "blocks.get.xml",
                 :bounces => "bounces.get.xml"
               }

    attr_reader :request, :response

    def initialize(name, options = {})
      raise ArgumentError, "Service #{name} is not supported" unless SERVICES.include?(name)
      user         = options.delete(:username) || API_USER
      password     = options.delete(:password) || API_KEY
      @service_name = name.to_sym
      @request      = HTTPI::Request.new
      params        = build_params(options)
      @request.url  = "#{BASE_URL}/#{SERVICES[@service_name]}?api_user=#{user}&api_key=#{password}#{params}"
      @response     = HTTPI.get(@request)
    end

    def parsed_response
      response_hash = Hash.from_xml(@response.body)
      name = @service_name.to_s.delete("_")
      response_hash[name][name.chop] if response_hash
    end

    private

    def build_params(options)
      options.map do |k,v|
        "&#{k}=#{v}"
      end.join
    end

  end
end