class PictureProcess
  DIRECTORY = 'product_pictures'
  LOGGER_FILE = STDOUT
  attr_accessor :params, :product_pictures, :return_hash, :user_email
  attr_reader :existent_product_ids
  @queue = 'low'

  def self.list(options={})
    directory.instance_variable_set('@files', nil)
    directory.files.all(delimiter: '/', prefix: options[:prefix]).common_prefixes
  end

  def self.perform(options={})
    self.new(options).perform
  end

  def self.is_pending?(hashopt={})
    is_working?(hashopt) || is_in_queue?(hashopt)
  end

  def has_pending_product_jobs?
    Resque.working.any? do |worker|
      payload = worker.job['payload']
      payload['class'] == PictureProcess::ProductPictures.to_s &&
        existent_product_ids.include?(payload['args'].first.to_i)
    end ||
    lambda {
      queue = "queue:#{PictureProcess::ProductPictures.instance_variable_get('@queue')}"
      jobs = Resque.redis.lrange(queue, 0, -1)
      jobs.any? do |job|
        j = Resque.decode(job)
        existent_product_ids.include?(j['args'][0].to_i)
      end
    }.call
  end

  def initialize(options={})
    @user_email = options['user_email']
    @key = options['key']
    @product_pictures = Hash.new
    @return_hash = {product_ids: [], errors: []}
    raise ArgumentError.new("Directory to process on S3 Bucket is necessary (key is nil)") if @key.blank?
  end

  def perform
    products_hash = retrieve_product_pictures
    create_product_picures products_hash
    loop do
      logger.debug('sleeping 30 seconds')
      sleep 30
      break unless self.has_pending_product_jobs?
    end
    check_failed_jobs
    logger.debug("Email será enviado agora")
    Admin::PictureProcessMailer.notify_picture_process(user_email, {'key' => @key}.merge(return_hash)).deliver
  end

  private

  def check_failed_jobs
    size = Resque::Failure.count
    index_to_remove = {}
    Resque::Failure.all(0, size + 1).each_with_index do |failed_job, index|
      if ((failed_job['payload']['class'] == PictureProcess::ProductPictures.to_s && existent_product_ids.include?(failed_job['payload']['args'][0].to_i)) rescue false)
        return_hash[:errors] << "Processamento do produto código: #{failed_job['payload']['args'][0].to_i} deu erro! Informe o TI. Mensagem: #{failed_job['error']}"
        index_to_remove[index] = failed_job
      end
    end

    if index_to_remove.size > 0
      _body = "<table><tr> <th>ID</th> <th>Falhou em</th> <th>Mensagem</th> <th>Payload</th> </tr>%s</table>"
      rows = []
      row = "<tr> <td>%s</td> <td>%s</td> <td>%s</td> <td>%s %s %s</td> </tr>"
      index_to_remove.each do |index, failed_job|
        rows.push(row % [ failed_job['payload']['args'][0], failed_job['failed_at'], failed_job['exception'], failed_job['payload']['class'], failed_job['worker'], failed_job['queue'] ])
        rows.push("<tr> <td colspan=4><pre>%s</pre></td> </tr>" % failed_job['backtrace'].join("\n"))
      end
      ActionMailer::Base.mail(:from => "dev.notifications@olook.com.br", :to => Setting.dev_notification_emails, :subject => "Failed Jobs on Processing Pictures #{Time.zone.now.strftime('%Y-%m-%d')}", :body => _body % rows.join).deliver
      index_to_remove.keys.sort { |a,b| b <=> a }.each do |index|
        Resque::Failure.remove(index)
      end
    end
  end

  def create_product_picures product_pictures
    @existent_product_ids = Set.new(Product.where(id: product_pictures.keys).pluck(:id))
    product_pictures.each do |key,val|
      if existent_product_ids.include?(key.to_i)
        return_hash[:product_ids] << key
      else
        return_hash[:errors] << "Produto código: #{key} não encontrado, verifique se o código está correto e se ele está no admin."
        next
      end

      if val.size == 0
        return_hash[:errors] << "Pasta do produto código #{key} não tem fotos, talvez a sincronização do diretório não terminou ou deu algum erro."
        next
      end

      Resque.enqueue(PictureProcess::ProductPictures, key, val)
    end
  end

  def retrieve_product_pictures
    files = self.class.directory.files.all(prefix: @key)
    return_hash[:errors] << "Não foi possivel encontrar nenhum arquivo nessa pasta" if files.empty?
    files.inject({}) do |h, f|
      if %r{/(?<product_id>\d+)/[^/]*$} =~ f.key
        h[product_id] ||= []
        h[product_id] << "https://s3.amazonaws.com/#{DIRECTORY}/#{f.key}" if %r{(?:sample|\d+).jpg$} =~ f.key
      end
      h
    end
  end

  def logger
    @logger ||= Logger.new(LOGGER_FILE)
  end

  def self.directory
    @@connection ||= Fog::Storage[:aws]
    @@directory ||= @@connection.directories.get(DIRECTORY)
  end

  def self.is_in_queue?(hashopt={})
    key = hashopt['key'] || hashopt[:key]
    queue = "queue:#{@queue}"
    jobs = Resque.redis.lrange(queue, 0, -1)
    jobs.any? do |job|
      j = Resque.decode(job)
      j['args'][0]['key'] == key
    end
  end

  def self.is_working?(hashopt={})
    key = hashopt['key'] || hashopt[:key]
    Resque.working.any? do |worker|
      worker.job['payload']['args'][0]['key'] == key rescue false
    end
  end
end

