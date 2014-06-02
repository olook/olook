require 'net/https'
require 'json'

class FacebookConnectService
  attr_reader :user, :email

  def initialize(auth_response_hash)
    @access_token = auth_response_hash['accessToken']
    @user_id = auth_response_hash['userId']
    @email = auth_response_hash['email']
  end

  def get_facebook_data
    fb_api('/me', @access_token)
  end

  def get_facebook_likes(facebook_token)
    # Tem que usar o Koala, pq pela API o nosso facebook_token nao funciona para obter os likes
    FacebookAdapter.new(facebook_token).adapter.get_connections('me', 'likes').try(:to_a) || []
  end

  def connect!
    @facebook_data = get_facebook_data   
    Rails.logger.info("[FACEBOOK] Retrieved data from facebook:#{@facebook_data}")
    
    if(@facebook_data.respond_to?(:[]) && @facebook_data['error'])
      return false
    end

    Rails.logger.info("[FACEBOOK] extending FB token.")
    extend_fb_token
    Rails.logger.info("[FACEBOOK] new token got:#{@access_token}")

    if existing_user
      Rails.logger.info("[FACEBOOK] this is existent user. Just update facebook data")
      @user = update_user
      @user.add_event(EventType::FACEBOOK_LOGIN)
    else
      Rails.logger.info("[FACEBOOK] this is a new user. Storing it in the database")
      @user = create_user
      @user.add_event(EventType::FACEBOOK_CONNECT)
    end

    facebook_likes = get_facebook_likes(@user.facebook_token)
    @user.update_attribute(:facebook_likes, facebook_likes)
    return true
  end

  private

  def extend_fb_token
    fb_api('/oauth/access_token', @access_token, {
      grant_type: 'fb_exchange_token',
      client_id: FACEBOOK_CONFIG['app_id'],
      client_secret: FACEBOOK_CONFIG['app_secret'],
      fb_exchange_token: @access_token })  do |response|
      /access_token=(?<long_lived_access_token>[^&]+)&expires=(?<long_lived_expires>.+)/ =~ response.read_body
      @access_token = long_lived_access_token
      @expires = long_lived_expires
    end
  end

  def existing_user
    @user = User.find_by_email(@facebook_data['email'])
    !!@user
  end

  def data_for_user
    us_birthday = @facebook_data['birthday'].to_s.split('/')
    {
      first_name: @facebook_data['first_name'],
      last_name: @facebook_data['last_name'],
      facebook_token: @access_token,
      uid: @facebook_data['id'],
      birthday: "#{us_birthday[2]}-#{us_birthday[0]}-#{us_birthday[1]}",
      facebook_data: @facebook_data
    }
  end

  def create_user
    @user = User.create(data_for_user.merge(email: @facebook_data['email'], facebook_data: @facebook_data))
    @user
  end

  def update_user
    data = data_for_user
    data.delete(:first_name)
    data.delete(:last_name)
    data.delete(:birthday)

    @user.update_attributes(data)
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
  def fb_api(url, access_token, attach = {}, request_type="GET", &parser)
    uri = URI("https://graph.facebook.com/#{url}")

    if access_token
      attach.merge!('access_token' => access_token)
    end

    if request_type == "GET"
      uri.query = URI.encode_www_form(attach)
      req = Net::HTTP::Get.new uri.request_uri

    elsif request_type == "POST"
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(attach)
    end

    res = Net::HTTP.new(uri.host, uri.port)
    res.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res.use_ssl = true

    response = nil
    res.start do |http|
      response = http.request(req)
    end
    if parser
      return parser.call(response)
    else
      return JSON.parse(response.read_body)
    end
  end
end
