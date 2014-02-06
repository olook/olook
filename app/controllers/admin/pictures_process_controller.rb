class PicturesProcessController < Admin::BaseController
  def index
    authorize! :new_multiple_pictures, Picture
  end

  def create
    authorize! :create_multiple_pictures, Picture
  end
end
