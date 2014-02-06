class Admin::PicturesProcessController < Admin::BaseController
  def index
    @connection = Fog::Storage.new({provider: 'AWS'})

    authorize! :new_multiple_pictures, Picture
  end

  def create
    authorize! :create_multiple_pictures, Picture
  end
end
