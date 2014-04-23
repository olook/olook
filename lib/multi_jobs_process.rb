module MultiJobsProcess
  MAX_TIME_IS_SECONDS = 2.hours.to_i

  #
  # To use a multijobs process you must overide the following methods:
  #
  # execute
  # split_data
  # join
  #
  #
  def already_started?
    REDIS.exists(cache_key)
  end

  def has_finished?
    elapsed_time = Time.zone.now - REDIS.get(cache_key).to_time
    REDIS.get(missing_key).to_i - REDIS.get(errors_key).to_i == 0 || elapsed_time > MAX_TIME_IS_SECONDS
  end

  def sleep
    Resque.enqueue_in(5.minutes, MultiWorkersProcessMaster, self.class.to_s)
  end

  def finish
    elapsed_time = Time.zone.now - REDIS.get(cache_key).to_time
    REDIS.del(cache_key)
    REDIS.del(missing_key)
    REDIS.del(errors_key)
    REDIS.del(cache_key + ":msg")
    elapsed_time.to_i
  end

  def cache_key
    self.class.name
  end

  def missing_key
    cache_key + ":missing"
  end

  def errors_key
    cache_key + ":errors"
  end

  def errors
    REDIS.get(errors_key).to_i
  end

  def error_messages
    REDIS.lrange(cache_key + ":msg", 0, -1)
  end


  def self.included(base)
    base.extend(ClassMethods)
  end

  def split(max=20)
    start(max)
    split_data(max).each_with_index do |data, index|
      data.merge!({index: index})
      Resque.enqueue(self.class, data)
    end
  end

  module ClassMethods

    def perform data
      slave_job = self.new
      begin
        slave_job.execute(data)
      rescue => e
        DevAlertMailer.notify({to: 'tech@olook.com.br', 
          subject: "Erro", body: e.backtrace.join("\n")}).deliver!
        
        puts "erro: #{e}"
        REDIS.incr(slave_job.errors_key)
        REDIS.lpush(slave_job.cache_key + ":msg", e.message)
        puts "Erro: #{e.message}"
      ensure
        missing_key = slave_job.missing_key
        REDIS.decr(missing_key) if REDIS.get(missing_key).to_i > 0
      end
    end

  end

  private 

    def start(max)
      REDIS.set(cache_key, Time.zone.now)
      REDIS.set(missing_key, max)
    end  

end
