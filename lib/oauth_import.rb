# -*- encoding : utf-8 -*-
require 'oauth'
require 'yaml'

module OauthImport
  class Yahoo
    attr_accessor = :oauth_token, :oauth_verifier

    def initialize(oauth_token=nil, oauth_verifier=nil)
      rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/..'
      rails_env = ENV['RAILS_ENV'] || 'development'

      yahoo_config = YAML.load_file(rails_root + '/config/yahoo.yml')
      @key = yahoo_config[rails_env]['api_key']
      @secret = yahoo_config[rails_env]['api_secret']
      @callback_uri = yahoo_config[rails_env]['callback_uri']

      @oauth_token = oauth_token
      @oauth_verifier = oauth_verifier
    end

    def contacts(token, secret, verifier)
      response = access_contacts(token, secret, verifier)
      json = decode_json(response.body)
      contacts = parse_json(json)
      contacts.to_a
    end

    def request
      consume.get_request_token(:oauth_callback => @callback_uri)
    end

    private

    def access_contacts(token, secret, verifier)
      request = OAuth::RequestToken.new(consume, token, secret)
      access_token = request.get_access_token(:oauth_verifier => verifier)
      access_token.consumer = consume_calendar
      guid = access_token.params[:xoauth_yahoo_guid]
      response = access_token.get("/v1/user/#{guid}/contacts?format=json&count=max")
    end

    def decode_json(json)
      ActiveSupport::JSON.decode(json)
    end

    def parse_json(json)
      contacts_map = {}
      json['contacts']['contact'].each do |contact|
        name, email = nil

        contact['fields'].each do |field|
          name = "#{field['value']['givenName']} #{field['value']['familyName']}" if field['type'] == 'name'
          email = field['value'] if field['type'] == 'email'
        end
        
        name ||= email
        contacts_map[name] = email
      end
      contacts_map
    end
  
    def consume_calendar
      OAuth::Consumer.new(@key, @secret, {
        :site => 'http://social.yahooapis.com'  
      })
    end

    def consume
      OAuth::Consumer.new(@key, @secret, {
        :site               => 'https://api.login.yahoo.com',
        :scheme             => :query_string,
        :request_token_path => '/oauth/v2/get_request_token',
        :access_token_path  => '/oauth/v2/get_token',
        :authorize_path     => '/oauth/v2/request_auth',
      })
    end

  end
end

