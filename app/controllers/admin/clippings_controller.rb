class Admin::ClippingsController < Admin::BaseController
  def index
    @clippings = Clipping.all
  end

  def new
    @clipping = Clipping.new
  end

  def edit
    @clipping = Clipping.find(params[:id])
  end

  def create
    @clipping = Clipping.new(params[:clipping])
    if @clipping.save
      redirect_to [:admin, @clipping], notice: I18n.t('activerecord.models.clipping.messages.successful.create')
    else
      render action: "new"
    end
  end

  def update
    @clipping = Clipping.find(params[:id])
    if @clipping.update_attributes(params[:clipping])
      redirect_to [:admin, @clipping], notice: I18n.t('activerecord.models.clipping.messages.successful.update')
    else
      render action: "edit"
    end

  end

  def destroy
    @clipping = Clipping.find(params[:id])
    @clipping.destroy
    redirect_to admin_clippings_url
  end
end
