# -*- encoding : utf-8 -*-
class MultiWorkersProcessMaster
  @queue = :low
  MAX = 10

  def self.perform worker_class=MultiWorkersProcessSlave
    if REDIS.exists(cache_key)

      if missing == 0
        puts "ACABOOOOOOOU"
        REDIS.del(cache_key)
      else
        # Resque.enqueue_in(self, 2.minutes)
        Resque.enqueue(self)
      end

    else
      puts "iniciado"
      REDIS.set(cache_key, Time.zone.now)
      self.missing=MAX

      REDIS.set("#{cache_key}:missing", MAX)

      split_data.each_with_index do |data, i|
        data.merge!({index: i})
        Resque.enqueue(worker_class, data, cache_key, "#{cache_key}:missing")
      end

      # Resque.enqueue_in(2.minutes, self)
      Resque.enqueue(self)
    end
    
  end

  def self.cache_key
    "MultiWorkersProcessMaster"
  end

  def self.missing
    REDIS.get("#{cache_key}:missing").to_i
  end

  def self.missing= value
    puts "Setado!!!!! #{value}"
    REDIS.set("#{cache_key}:missing", value)
  end

	def self.split_data
    total = User.count
    num_of_records = total / MAX
    left = total % MAX + 1

    (0...MAX).map do |i|
      first = i * num_of_records
      last = num_of_records * (i+1) - 1
      last += left if i == (MAX - 1)
      {first: first, last: last}
    end    
  end

end