class Leaderboard
  def initialize(options={})
    @redis = options.delete(:redis)
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
      @redis.zincrby(key, 1, id)
    end
  end

  def rank(limit)
    @redis.zrevrange(@key, 0, limit - 1)
  end
end
