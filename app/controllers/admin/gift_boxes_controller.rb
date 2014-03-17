class Admin::GiftBoxesController < Admin::BaseController
  load_and_authorize_resource
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
    params[:gift_box][:thumb_image].tempfile = nil if params[:gift_box][:thumb_image]
    flash[:notice] = 'Gift Box Type criada com sucesso.' if @gift_box.save
    respond_with :admin, @gift_box
  end

  def show
    @gift_box = GiftBox.find(params[:id])
    @gift_box_products = @gift_box.gift_boxes_product.joins(:product).includes(:product).order("collection_id desc, category, name")
    respond_with :admin, @gift_box
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

  def get_all_products
    #@products = Product.joins(:collection).joins('left outer join gift_boxes_products on products.id = gift_boxes_products.product_id').where("collections.start_date >= :date or (gift_boxes_products.gift_box_id = :gift_box_id and gift_boxes_products.product_id = products.id)", date: 3.months.ago.beginning_of_month, gift_box_id: @gift_box.id).order("collection_id desc, category, name").uniq
    @products = Collection.active.products
  end

  def product
    @gift_box = GiftBox.find(params[:gift_box_id])
    get_all_products
    respond_with :admin, @gift_box
  end
end
