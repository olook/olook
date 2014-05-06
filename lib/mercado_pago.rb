#MercadoPago Integration Library
#Access MercadoPago for payments integration
#
#@author @maticompiano
#@contributors @chrismo

require 'rubygems'
require 'json/add/core'
require 'uri'
require 'net/https'
require 'yaml'
require 'version'

class MercadoPago
  def initialize(client_id, client_secret, debug_logger=nil)
    @client_id = client_id
    @client_secret = client_secret
    @rest_client = RestClient.new(debug_logger)
    @sandbox = ! Rails.env.production?
  end

  def init_point
    @sandbox ? 'sandbox_init_point' : 'init_point'
  end

  def set_debug_logger(debug_logger)
    @rest_client.set_debug_logger(debug_logger)
  end

  def sandbox_mode(enable=nil)
    if not enable.nil?
      @sandbox = enable
    end

    return @sandbox
  end

  # Get Access Token for API use
  def get_access_token
    app_client_values = {
      'grant_type' => 'client_credentials',
      'client_id' => @client_id,
      'client_secret' => @client_secret
    }

    @access_data = @rest_client.post("/oauth/token", build_query(app_client_values), RestClient::MIME_FORM)

    if @access_data['status'] == "200"
      @access_data = @access_data["response"]
      @access_data['access_token']
    else
      raise @access_data.inspect
    end
  end

  # Get information for specific payment
  def get_payment(id)
    uri_prefix = @sandbox ? "/sandbox" : ""
    request(:get, uri_prefix + "/collections/notifications/" + id)
  end

  def get_payment_info(id)
    get_payment(id)
  end

  # Get information for specific authorized payment
  def get_authorized_payment(id)
    request(:get, "/authorized_payments/" + id)
  end

  # Refund accredited payment
  def refund_payment(id)
    refund_status = {"status" => "refunded"}
    request(:put, "/collections/" + id, refund_status)
  end

  # Cancel pending payment
  def cancel_payment(id)
    cancel_status = {"status" => "cancelled"}
    request(:put, "/collections/#{id}", cancel_status)
  end

  # Cancel preapproval payment
  def cancel_preapproval_payment(id)
    cancel_status = {"status" => "cancelled"}
    request(:put, "/preapproval/" + id, cancel_status)
  end

  # Search payments according to filters, with pagination
  def search_payment(filters, offset=0, limit=0)
    filters["offset"] = offset
    filters["limit"] = limit

    filters = build_query(filters)

    uri_prefix = @sandbox ? "/sandbox" : ""
    request(:get, uri_prefix + "/collections/search?" + filters)
  end

  # Create a checkout preference
  def create_preference(preference)
    request(:post, "/checkout/preferences", preference)
  end

  # Update a checkout preference
  def update_preference(id, preference)
    request(:put, "/checkout/preferences/" + id, preference)
  end

  # Get a checkout preference
  def get_preference(id)
    request(:get, "/checkout/preferences/" + id)
  end

  # Create a preapproval payment
  def create_preapproval_payment(preapproval_payment)
    request(:post, "/preapproval", preapproval_payment)
  end

  # Get a preapproval payment
  def get_preapproval_payment(id)
    request(:get, "/preapproval/" + id)
  end

  def build_query(params)
    URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
  end

  private

  def request(method, uri, data=nil)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    fs = ( /\?/ =~ uri.to_s ? "&" : "?" )
    case method
    when :get
      @rest_client.get("#{uri}#{fs}access_token=#{access_token}")
    when :post
      @rest_client.post("#{uri}#{fs}access_token=#{access_token}", data)
    when :put
      @rest_client.put("#{uri}#{fs}access_token=#{access_token}", data)
    end
  end

    class RestClient

      MIME_JSON = 'application/json'
      MIME_FORM = 'application/x-www-form-urlencoded'
      API_BASE_URL = URI.parse('https://api.mercadolibre.com')

      def initialize(debug_logger=nil)
        @http = Net::HTTP.new(API_BASE_URL.host, API_BASE_URL.port)

        if API_BASE_URL.scheme == "https" # enable SSL/TLS
          @http.use_ssl = true
          @http.ssl_version = :SSLv3
          @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          @http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
        end

        @http.set_debug_output debug_logger if debug_logger
      end

      def set_debug_logger(debug_logger)
        @http.set_debug_output debug_logger
      end

      def exec(method, uri, data, content_type)
        if not data.nil? and content_type == MIME_JSON
          data = data.to_json
        end

        headers = {
          'User-Agent' => "MercadoPago Ruby SDK v" + MERCADO_PAGO_VERSION,
          'Content-type' => content_type,
          'Accept' => MIME_JSON
        }

        api_result = @http.send_request(method, uri, data, headers)

        {
          "status" => api_result.code,
          "response" => JSON.parse(api_result.body)
        }
      end

      def get(uri, content_type=MIME_JSON)
        exec("GET", uri, nil, content_type)
      end

      def post(uri, data = nil, content_type=MIME_JSON)
        exec("POST", uri, data, content_type)
      end

      def put(uri, data = nil, content_type=MIME_JSON)
        exec("PUT", uri, data, content_type)
      end
    end
end
