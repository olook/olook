class Admin::GiftBoxesController < Admin::BaseController
  def index
    @gift_boxes = GiftBox.all
  end

  def new
  end

  def create
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
    respond_with :admin, @gift_box
  end

  def destroy
  end
end
