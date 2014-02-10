class Admin::PicturesProcessController < Admin::BaseController
  def index
    @keys = PictureProcess.new(prefix: params[:prefix]).list
    authorize! :new_multiple_pictures, Picture
  end

  def create
    authorize! :create_multiple_pictures, Picture
  end
end
