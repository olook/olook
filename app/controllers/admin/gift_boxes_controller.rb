class Admin::GiftBoxesController < Admin::BaseController

  respond_to :html
  def index
    @gift_boxes = GiftBox.all
  end

  def new
    @gift_box = GiftBox.new
    respond_with :admin, @gift_box
  end

  def create
    @gift_box = GiftBox.new(params[:gift_box])
    flash[:notice] = 'Gift Box Type criada com sucesso.' if @gift_box.save
    respond_with :admin, @gift_box
  end

  def show
    @gift_box = GiftBox.find(params[:id])
    respond_with :admin, @gift_box
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
