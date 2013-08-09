class QuizResponder
  ROUTES = Rails.application.routes.url_helpers
  attr_accessor :uuid, :profile, :quiz, :user, :next_step

  def self.find(uuid)
    json = redis.get(redis_key(uuid))
    if json
      hash = JSON.parse(json)
    else
      hash = {}
    end
    self.new(hash)
  end

  def initialize(attrs = {})
    @uuid = attrs[:uuid] || attrs['uuid']
    @profile = attrs[:profile] || attrs['profile']
    @questions = attrs[:questions] || attrs['questions']
    @name = attrs[:name] || attrs['name']
    @user = attrs[:user] || attrs['user']
    @next_step = ROUTES.wysquiz_path
    @user_data = attrs[:user_data] || attrs['user_data']
  end

  def save
    serial = {
      uuid: @uuid,
      profile: @profile,
      user_data: @user_data
    }
    redis.set(self.class.redis_key(uuid), JSON.generate(serial))
  end

  def destroy
    redis.del(self.class.redis_key(uuid))
  end

  def update_profile
    @user.profile = @profile
    @user.profiles = [Profile.for_wysprofile(@profile).first]
    @user.wys_uuid = @uuid
    @user.save
  end

  def retrieve_profile
    result = api.profile_from(name: @name, answers: @questions)

    @uuid = result[:uuid]
    @profile = result[:profile]
    self
  end

  def validate!
    if !has_profile?
      if can_ask_for_profile?
        retrieve_profile
      else
        @next_step = ROUTES.wysquiz_path
        return self
      end
    end

    if @user.blank?
      save
      @next_step = ROUTES.join_path(uuid: @uuid)
      return self
    end
    update_profile
    destroy

    @next_step = ROUTES.profile_path(f: "1")
    self
  end

  private

  def can_ask_for_profile?
    @name.present? && @questions.present?
  end

  def has_profile?
    @profile.present? && @uuid.present?
  end

  def api
    @api = WhatsYourStyle::Quiz.new
    @api.logger = Rails.logger
    @api
  end

  def self.redis
    aux = ( ENV['QUIZ_RESPONDER_REDIS'] || '127.0.0.1:6379/0' ).split(':')
    host = aux.shift
    port, db = aux.shift.to_s.split('/')
    Redis.new(host: host, port: port, db: db)
  end

  def redis
    self.class.redis
  end

  def self.redis_key(uuid)
    "qr:#{uuid}"
  end
end
