# -*- encoding : utf-8 -*-

module EmailMarketing
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

    def initialize(name)
      raise ArgumentError, "Service #{name} is not supported" unless SERVICES.include?(name)
      @service_name = name
      @request = HTTPI::Request.new
      @request.url = "#{BASE_URL}/#{SERVICES[name]}?api_user=#{API_USER}&api_key=#{API_KEY}"
      @response = HTTPI.get(@request)
    end

    def parsed_response
      response_hash = Hash.from_xml(@response.body)
      name = @service_name.to_s.delete("_")
      response_hash[name][name.chop] if response_hash
    end
  end
end