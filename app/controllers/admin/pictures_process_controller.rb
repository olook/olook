class Admin::PicturesProcessController < Admin::BaseController
  def index
    @connection = Fog::Storage[:aws]
    @directory = @connection.directories.get('product_pictures')
    @keys = @directory.files.all(delimiter: '/', prefix: params[:prefix]).common_prefixes
    @keys = @directory.files.all(prefix: params[:prefix]) if @keys.empty?
    authorize! :new_multiple_pictures, Picture
  end

  def create
    authorize! :create_multiple_pictures, Picture
  end
end
