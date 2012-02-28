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
                 :blocks => "blocks.get.xml"
               }

    attr_reader :request, :response

    def initialize(name, options = nil)
      raise ArgumentError, "Service #{name} is not supported" unless SERVICES.include?(name)

      @user         = options && options.include?(:username) ? options[:username] : API_USER
      @password     = options && options.include?(:password) ? options[:password] : API_KEY
      @service_name = name.to_sym
      @request      = HTTPI::Request.new
      @request.url  = "#{BASE_URL}/#{SERVICES[@service_name]}?api_user=#{@user}&api_key=#{@password}"
      @response     = HTTPI.get(@request)
    end

    def parsed_response
      response_hash = Hash.from_xml(@response.body)
      name = @service_name.to_s.delete("_")
      response_hash[name][name.chop] if response_hash
    end
  end
end