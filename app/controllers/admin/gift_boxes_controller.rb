class Admin::GiftBoxesController < Admin::BaseController
  def index
    @gift_boxes = GiftBox.all
  end

  def new
  end

  def create
    @gift_box = GiftBox.new(params[:gift_box])
    params[:gift_box][:thumb_image].tempfile = nil if params[:gift_box][:thumb_image]
    flash[:notice] = 'Gift Box Type criada com sucesso.' if @gift_box.save
    respond_with :admin, @gift_box
  end

  def update
  end

  def edit
    @gift_box = GiftBox.find(params[:id])
    respond_with :admin, @gift_box
  end

  def update
    @gift_box = GiftBox.find(params[:id])
    flash[:notice] = 'Gift Box Type atualizada com sucesso.' if @gift_box.update_attributes(params[:gift_box])
    params[:gift_box][:thumb_image].tempfile = nil if params[:gift_box][:thumb_image]
    respond_with :admin, @gift_box
  end

  def destroy
    @gift_box = GiftBox.find(params[:id])
    flash[:notice] = 'Gift Box Type deletada com sucesso.' if @gift_box.destroy
    respond_with :admin, @gift_box
  end
end
