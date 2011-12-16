# -*- encoding : utf-8 -*-

module EmailMarketing
  class SendgridClient

    BASE_URL = "https://sendgrid.com/api"
    API_USER = "olook"
    API_KEY = "olook123abc"
    SERVICES = {
                 :invalid_emails => "invalidemails.get.json",
                 :spam_reports => "spamreports.get.json",
                 :unsubscribes => "unsubscribes.get.json",
                 :blocks => "blocks.get.json"
               }

    def initialize(name)
      raise ArgumentError, "Service #{name} is not supported" unless SERVICES.include?(name)

      @request = HTTPI::Request.new
      @request.url = "#{BASE_URL}/#{SERVICES[name]}?api_user=#{API_USER}&api_key=#{API_KEY}"
      @response = HTTPI.get(@request)
    end

    def parsed_response
      JSON::parse(@response.body)
    end
  end
end