# -*- encoding : utf-8 -*-
class MultiWorkersProcessMaster
  @queue = :low
  MAX = 10

  def self.perform worker_class=MultiWorkersProcessSlave
    if process_already_started?

      if has_finished?
        REDIS.del(cache_key)
        REDIS.del(missing_key)

        join

      else
        reschedule(self)
      end

    else
      start_master_process

      split_data.each_with_index do |data, i|
        start_slave_process(data, i)
      end

      reschedule(self)
    end
    
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

  def self.start_master_process 
    REDIS.set(cache_key, Time.zone.now)
    REDIS.set("#{cache_key}:missing", MAX)
  end

  def self.start_slave_process data, index
    data.merge!({index: index, cache_key: cache_key, missing_key: missing_key})
    Resque.enqueue(MultiWorkersProcessSlave, data)
  end

  def self.join
    connection = Fog::Storage.new provider: 'AWS'
    dir = connection.directories.get(Rails.env.production? ? "olook-ftp" : "olook-ftp-dev")
    files = dir.files.select{|file| file.key.match( /base_geral\/fragment/) }.map{|file| file.key}

    begin
      open("tmp/base_atualizada.csv", 'wb') do |f|
        # header
        f << ['first_name', 'email address', 'created_at, total' ].join(';')
        f << "\n"
        files.each do |path|
          puts "baixando #{path}"
          dir.files.get(path) do |chunk, remaining, total|
            f.write chunk
          end
          puts "arquivo concluido."
        end
      end

      # upload
      MarketingReports::S3Uploader.new('allin').copy_file('base_atualizada.csv')

    rescue => e
      puts e
    end

    puts "Tudo concluido"

    #send an email
    DevAlertMailer.notify({to: 'rafael.manoel@olook.com.br', subject: 'geração da base concluída'}).deliver!    
    
  end

  private
    def self.cache_key
      "MultiWorkersProcessMaster"
    end

    def self.missing_key
      "#{cache_key}:missing"
    end

    def self.missing
      REDIS.get("#{cache_key}:missing").to_i
    end

    def self.missing= value
      REDIS.set("#{cache_key}:missing", value)
    end


    def self.process_already_started?
      REDIS.exists(cache_key)
    end

    def self.has_finished?
      missing == 0
    end

    def self.reschedule process
      # Resque.enqueue_in(2.minutes, process)
      Resque.enqueue(process)
    end

end