module MultiJobsProcess

  #
  # To use a multijobs process you must overide the following methods:
  #
  # execute
  # split_data
  # join
  #
  #
  
  def max
    20
  end

  def already_started?
    REDIS.exists(cache_key)
  end

  def has_finished?
    REDIS.get(missing_key).to_i == 0
  end

  def sleep
    Resque.enqueue(MultiWorkersProcessMaster, self.class.to_s)
  end

  def finish
    elapsed_time = Time.zone.now - REDIS.get(cache_key).to_time
    REDIS.del(cache_key)
    REDIS.del(missing_key)
    elapsed_time.to_i
  end

  def start
    REDIS.set(cache_key, Time.zone.now)
    REDIS.set(missing_key, max)
  end

  def cache_key
    puts self.class.name
    self.class.name
  end

  def missing_key
    cache_key + ":missing"
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def split
    split_data.each_with_index do |data, index|
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
        # Adicionar o tratamente de erros
        puts e
      ensure
        missing_key = slave_job.missing_key
        REDIS.decr(missing_key) if REDIS.get(missing_key).to_i > 0
      end
    end

  end


end