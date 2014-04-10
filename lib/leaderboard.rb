class Leaderboard
  PREFIX = 'leaderboard/'
  def self.clear
    redis = Redis.new(url: ENV['REDIS_LEADERBOARD'])
    keys = redis.keys("#{PREFIX}*")
    redis.del(*keys)
  end

  def initialize(options={})
    @redis = options.delete(:redis) || Redis.new(url: ENV['REDIS_LEADERBOARD'])
    @key = options.delete(:key)
    @keys = [@key]
    aux_key = @key.split(':')
    aux_key.pop
    while aux_key.size > 0
      @keys.push(aux_key.join(':'))
      aux_key.pop
    end
  end

  def score(id)
    @keys.each do |key|
      @redis.zincrby("#{PREFIX}#{key}", 1, id)
    end
  end

  def rank(limit)
    @redis.zrevrange("#{PREFIX}#{@key}", 0, limit - 1)
  end
end
