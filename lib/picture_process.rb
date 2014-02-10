class PictureProcess
  DIRECTORY = 'product_pictures'
  attr_accessor :params
  @queue = 'low'

  def self.list(options={})
    @@connection ||= Fog::Storage[:aws]
    @@directory ||= @@connection.directories.get(DIRECTORY)
    @@directory.instance_variable_set('@files', nil)
    @@directory.files.all(delimiter: '/', prefix: options[:prefix]).common_prefixes
  end

  def self.perform(options={})
    self.new(options).perform
  end

  def initialize(options={})
    @key = options[:key]
    raise ArgumentError.new("Directory to process on S3 Bucket is necessary (key is nil)") if @key.blank?
  end

  def perform
    puts "Fazendo a porra toda"
  end
end
