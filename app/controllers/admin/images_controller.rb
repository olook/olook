class Admin::ImagesController < Admin::BaseController
  before_filter :load_lookbook
  respond_to :html

   def show
    @image = @lookbook.images.find(params[:id])
    respond_with :admin, @image
  end

  def new
    @image = @lookbook.images.build
    respond_with :admin, @lookbook, @image
  end

  def edit
    @image = @lookbook.images.find(params[:id])
    respond_with :admin, @lookbook, @image
  end

  def create
    @image = @lookbook.images.build(params[:image])

    if @image.save
      flash[:notice] = 'image was successfully created.'
    end

    respond_with :admin, @lookbook, @image
  end

  def update
    @image = @lookbook.images.find(params[:id])

    if @image.update_attributes(params[:image])
      flash[:notice] = 'image was successfully updated.'
    end

    respond_with :admin, @lookbook, @image
  end

  def destroy
    @image = @lookbook.images.find(params[:id])
    @image.destroy
    respond_with [:admin, @lookbook]
  end

  def new_multiple_images
    return redirect_to [:admin, @lookbook], :notice => 'lookbook already has images' unless @lookbook.images.empty?
    respond_with :admin, @lookbook
  end

  def create_multiple_images
    @lookbook.update_attributes(params[:lookbook])
    if @lookbook.save
      flash[:notice] = 'images were successfully created.'
      redirect_to [:admin, @lookbook]
    else
      flash[:notice] = 'Erro'
      render :new_multiple_images
    end
  end

  private
  def load_lookbook
    @lookbook = Lookbook.find(params[:lookbook_id])
  end

end

