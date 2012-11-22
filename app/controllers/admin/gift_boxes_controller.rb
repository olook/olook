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
  end

  def destroy
  end
end
