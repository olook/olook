class Leaderboard
  PREFIX = 'leaderboard'
  def self.clear
    redis = Redis.connect(url: ENV['REDIS_LEADERBOARD'])
    keys = redis.keys("#{PREFIX}*")
    redis.del(*keys)
  end

  def initialize(options={})
    @redis = options.delete(:redis) || Redis.connect(url: ENV['REDIS_LEADERBOARD'])
    @key = [PREFIX, options.delete(:key)].compact.join(':')
    @keys = [@key]
    aux_key = @key.split(':')
    aux_key.pop
    while aux_key.size > 0
      @keys.push(aux_key.join(':'))
      aux_key.pop
    end
  rescue
  end

  def score(id)
    @keys.each do |key|
      @redis.zincrby(key, 1, id)
    end
  rescue
  end

  def rank(limit, opts={})
    @redis.zrevrange(@key, 0, limit - 1, opts)
  rescue
    []
  end
end
