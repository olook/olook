class PictureProcess
  DIRECTORY = 'product_pictures'
  attr_accessor :params, :product_pictures
  @queue = 'low'

  def self.list(options={})
    @@directory ||= self.connection
    @@directory.instance_variable_set('@files', nil)
    @@directory.files.all(delimiter: '/', prefix: options[:prefix]).common_prefixes
  end

  def self.perform(options={})
    self.new(options).perform
  end

  def self.is_pending?(*args)
    is_working?(*args) || is_in_queue?(*args) 
  end

  def initialize(options={})
    @key = options['key']
    @product_pictures = Hash.new
    raise ArgumentError.new("Directory to process on S3 Bucket is necessary (key is nil)") if @key.blank?
  end

  def perform
    products_hash = retreive_product_pictures
    create_product_picures products_hash
    puts "Fazendo a porra toda"
    sleep 600
  end

  private

  def create_product_picures product_pictures
    product_pictures.each do |key,val|
      product = Product.find key
      product.remote_color_sample_url = val.select{|image| image =~ /sample/i}.first
      product.save
      product.pictures.destroy_all if product.pictures.count > 1
      val.each_with_index do |image,index|
        unless image =~ /sample/i
          picture = Picture.new(product: product, display_on: index + 1)
          picture.remote_image_url = image 
          picture.save
        end
      end
    end
  end

  def retreive_product_pictures
    get_files.map do |file|
      product_number = file.gsub(/\D/, '')
      arr = self.class.directory.files.all(delimiter: '/', prefix: file).select{|image| /\/(?:sample|\d+).jpg$/i =~ image.key}.map{|f| f.public_url}
      product_pictures[product_number] = arr 
      product_pictures
    end
    product_pictures
  end

  def get_files
    self.class.directory.files.all(delimiter: '/', prefix: @key).common_prefixes
  end

  def self.directory
    connection ||= Fog::Storage[:aws]
    connection.directories.get(DIRECTORY)
  end

  def self.is_in_queue?(*args)
    key = Resque.encode(class: self.to_s, args: args)
    queue = "queue:#{@queue}"
    jobs = Resque.redis.lrange(queue, 0, -1)
    jobs.any? do |job|
      job == key
    end
  end

  def self.is_working?(*args)
    key = Resque.decode(Resque.encode( class: self.to_s, args: args ))
    Resque.working.any? do |worker|
      worker.job['payload'] == key
    end
  end
end

