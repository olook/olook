require 'net/https'
require 'json'

class FacebookConnectService
  attr_reader :user

  def initialize(auth_response_hash)
    @access_token = auth_response_hash['accessToken']
    @user_id = auth_response_hash['userId']
  end

  def get_facebook_data
    fb_api('/me', @access_token)
  end

  def connect!
    @facebook_data = get_facebook_data
    if(@facebook_data.respond_to?(:[]) && @facebook_data['error'])
      return false
    end

    if existing_user
      @user = update_user
    else
      @user = create_user
    end
    return true
  end

  private

  def existing_user
    @user = User.find_by_email(@facebook_data['email'])
    !!@user
  end

  def data_for_user
    us_birthday = @facebook_data['birthday'].to_s.split('/')
    {
      first_name: @facebook_data['first_name'],
      last_name: @facebook_data['last_name'],
      authentication_token: @access_token,
      uid: @facebook_data['id'],
      birthday: "#{us_birthday[2]}-#{us_birthday[0]}-#{us_birthday[1]}"
    }
  end

  def create_user
    @user = User.create(data_for_user.merge(email: @facebook_data['email']))
    @user
  end

  def update_user
    @user.update_attributes(data_for_user)
    @user
  end

  # Allows to make GET or POST requests to the facebook API graph
  # the url parameter is the last part of the fb url excluding the https:/graph.facebook.com/
  # It returns a dict from a JSON data structure.
  #
  # Note: You can also use open-uri for simple GET requests like this:
  # obj = JSON.parse(open("https://graph.facebook.com/#{uid}?fields=id&access_token=#{access_token}").read)
  # The problem is that in case
  # of errors it raises a 400 HTTPBadRequest and it doesn't return any content of the body.
  # Therefore, since the errors of a facebook request are inside the body of the response
  # you couldn't get any fb errors from the simple function open.
  def fb_api(url, access_token, attach = {}, request_type="GET")
    uri = URI("https://graph.facebook.com/#{url}")

    if request_type == "GET"
      uri.query = URI.encode_www_form(attach.merge('access_token' => access_token))
      req = Net::HTTP::Get.new uri.request_uri

    elsif request_type == "POST"
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(attach.merge('access_token' => access_token))
    end

    res = Net::HTTP.new(uri.host, uri.port)
    res.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res.use_ssl = true

    response = nil
    res.start do |http|
      response = http.request(req)
    end

    return JSON.parse(response.read_body)
  end
end
