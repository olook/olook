class QuizResponder
  attr_accessor :uuid, :profile, :quiz

  def self.find(uuid)
    json = redis.get(redis_key(uuid))
    hash = JSON.parse(json)
    self.new(hash)
  end

  def initialize(attrs = {})
    @uuid = attrs[:uuid] || attrs['uuid']
    @profile = attrs[:profile] || attrs['profile']
    @questions = attrs[:questions] || attrs['questions']
    @name = attrs[:name] || attrs['name']
  end

  def save
    serial = {
      uuid: @uuid,
      profile: @profile
    }
    redis.set(self.class.redis_key(uuid), JSON.generate(serial))
  end

  def destroy
    redis.del(self.class.redis_key(uuid))
  end

  private

  def self.redis
    aux = ( ENV['QUIZ_RESPONDER_REDIS'] || '127.0.0.1:6379/0' ).split(':')
    host = aux.shift
    port, db = aux.split('/')
    Redis.new(host: host, port: port, db: db)
  end

  def redis
    self.class.redis
  end

  def self.redis_key(uuid)
    "qr:#{uuid}"
  end
end
