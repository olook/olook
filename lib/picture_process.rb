class PictureProcess
  DIRECTORY = 'product_pictures'
  LOGGER_FILE = STDOUT
  attr_accessor :params, :product_pictures, :return_hash, :user_email
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
    Admin::PictureProcessMailer.notify_picture_process(user_email, return_hash).deliver
  end

  private

  def create_product_picures product_pictures
    product_pictures.each do |key,val|
      time_start = Time.zone.now
      logger.debug("Initializing PictureProcess for product #{key} with #{val.size} pictures")
      product = Product.find_by_id key
      if product.nil?
        return_hash[:errors] << "Produto não encontrado - #{key}"
        next
      else
        return_hash[:product_ids] << key
      end

      product.pictures.destroy_all if product.pictures.count > 1
      t = []
      val.each_with_index do |image|
        if /sample/i =~ image
          product.remote_color_sample_url = image
          product.save
        else
          %r{/(?<display>\d+).jpg$}i =~ image
          picture = Picture.new(product: product, display_on: display)
          picture.remote_image_url = image
          picture.save
        end
      end
      logger.debug('Finished in %.2fms' % ( ( Time.zone.now - time_start ) * 1000 ) )
    end
  end

  def retrieve_product_pictures
    files = self.class.directory.files.all(prefix: @key)
    return_hash[:errors] << "Não foi possivel encontrar nenhum arquivo nessa pasta" if files.empty?
    files.inject({}) do |h, f|
      if %r{/(?<product_id>\d+)/(?:sample|\d+).jpg$} =~ f.key
        h[product_id] ||= []
        h[product_id] << "https://s3.amazonaws.com/#{DIRECTORY}/#{f.key}"
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
      worker.job['payload']['args'][0]['key'] == key
    end
  end
end

