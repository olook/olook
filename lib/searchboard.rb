class Searchboard

  PREFIX = 'searchboard'

  def self.clear
    redis = Redis.connect(url: ENV['REDIS_LEADERBOARD'])
    keys = redis.keys("#{PREFIX}*")
    redis.del(*keys) if keys.size > 0
  end

  def initialize
    @redis = Redis.connect(url: ENV['REDIS_LEADERBOARD'])
  end

  def add(term, amount)
    @redis.incrby([PREFIX, term, 'results'].join(':'), amount)
    @redis.incr([PREFIX, term, 'requests'].join(':'))

    @redis.sadd([PREFIX, "terms"].join(':'), term)

  end

  def get_report
    terms = @redis.smembers("#{PREFIX}:terms")

    terms.map {|term| 
       [
        term,
        @redis.get("#{PREFIX}:#{term}:requests"), 
        @redis.get("#{PREFIX}:#{term}:results")
      ]
    }
    
  end

  def print_report
    CSV.generate({col_sep: ';'}) do |csv|
      csv << ["Termo", "requisicoes","resultados","media"]
      get_report.each do |line|
        term = line[0]
        requests = line[1].to_i
        results = line[2].to_i
        csv << [term, requests, results, results / requests]
      end
    end
  end

end
