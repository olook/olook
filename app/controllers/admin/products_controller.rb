# -*- encoding : utf-8 -*-
class Admin::ProductsController < Admin::BaseController
  load_and_authorize_resource

  respond_to :html

  def index
    @liquidation = LiquidationService.active
    @sync_event = SynchronizationEvent.new
    # search params
    @collections = Collection.order(:name)
    @categories = [["Sapatos", Category::SHOE] , ['Bolsas', Category::BAG], ['Acessórios', Category::ACCESSORY]]
    @profiles = Profile.all

    @products = Product.includes(:profiles).includes(:collection)
                       .search(params[:q])
                       .in_category(params[:cat])
                       .in_collection(params[:col])
                       .in_profile(params[:p])
                       .order(sort_column + " " + sort_direction)
                       .order("collection_id desc, category, name")
                       .paginate(page: params[:page], per_page: 10)

    respond_with :admin, @products
  end

  def show
    @product = Product.find(params[:id])
    @related_product = RelatedProduct.new
    respond_with :admin, @product
  end

  def new
    @product = Product.new
    respond_with :admin, @product
  end

  def edit
    @product = Product.find(params[:id])
    respond_with :admin, @product
  end

  def create
    @product = Product.new(params[:product])

    if @product.save
      flash[:notice] = 'Product was successfully created.'
    end

    respond_with :admin, @product
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
    end

    respond_with :admin, @product
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    respond_with :admin, @product
  end

  def sync_products
    @products = Product.all
    @sync_event = SynchronizationEvent.new(:name => 'products')
    if @sync_event.save
      redirect_to admin_products_path
    else
      render :index
    end
  end

  def add_related
    @product =  Product.find(params[:id])
    product_to_relate = Product.find(params[:related_product][:id])
    @product.relate_with_product(product_to_relate)

    redirect_to admin_product_path(@product)
  end

  def remove_related
    @product = Product.find(params[:id])
    related_product = Product.find(params[:related_product_id])
    @product.unrelate_with_product(related_product)

    redirect_to admin_product_path(@product)
  end

  def autocomplete_information
    if params[:term] =~ /\A[A-Za-z]+/
      @products = Product.only_visible.where("name like ?", "%#{params[:term]}%").limit(10)
    elsif params[:term] =~ /\A[0-9]+/
      @products = Product.only_visible.where("model_number like ?", "%#{params[:term]}%").limit(10)
    else
      @products = []
    end

    render json: @products.map { |prod|
      {
        id: prod.id,
        image: prod.thumb_picture,
        name: prod.name
      }
    }
  end

  private
  helper_method :sort_column, :sort_direction
  def sort_column
    Product.column_names.include?(params[:s]) ? params[:s] : "collection_id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:d]) ? params[:d] : "desc"
  end
end

