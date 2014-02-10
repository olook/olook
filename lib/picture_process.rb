class PictureProcess
  DIRECTORY = 'product_pictures'
  attr_accessor :params

  def initialize(options={})
    @@connection ||= Fog::Storage[:aws]
    @@directory ||= @@connection.directories.get(DIRECTORY)
    @@directory.instance_variable_set('@files', nil)
    @params = options
  end

  def list
    @@directory.files.all(delimiter: '/', prefix: params[:prefix]).common_prefixes
  end
end
