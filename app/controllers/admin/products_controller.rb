# -*- encoding : utf-8 -*-
class Admin::ProductsController < Admin::BaseController
  load_and_authorize_resource

  respond_to :html

  def index
    @liquidation = LiquidationService.active
    @sync_event = SynchronizationEvent.new

    # search params
    @collections = {}
    Collection.order(:start_date).each do |collection|
      year = collection.try(:start_date).try(:year)
      if year
        @collections[year] ||= []
        @collections[year] << [collection.name, collection.id]
      end
    end

    @categories = [["Sapatos", Category::SHOE] , ['Bolsas', Category::BAG], ['Acessórios', Category::ACCESSORY], ['Roupas', Category::CLOTH]]
    @profiles = Profile.order(:name)

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

  def add_freebie
    @product = Product.find(params[:id])
    freebie = Product.find(params[:freebie_id])

    @product.add_freebie freebie
    redirect_to admin_product_path(@product)    
  end

  def remove_freebie
    @product = Product.find(params[:id])
    freebie = Product.find(params[:freebie_id])

    @product.remove_freebie(freebie)
    redirect_to admin_product_path(@product)
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
    @products =  if params[:term] =~ /\A[A-Za-z]+/
      Product.only_visible.where("name like ?", "%#{params[:term]}%").limit(10)
    elsif params[:term] =~ /\A[0-9]+/
      Product.only_visible.where("model_number like ?", "%#{params[:term]}%").limit(10)
    else
      []
    end

    render json: @products.map { |prod|
      {
        id: prod.id,
        image: prod.thumb_picture,
        name: prod.name
      }
    }
  end

  def mark_specific_products_as_visible
    @collection = Collection.find(params[:collection_id])
    visible_products = params[:visible_products] ? params[:visible_products].collect { |i| i.to_i } : []
    invisible_products = @collection.products.collect { |p| p.id } - visible_products
    visible_products

    if update_all_products(visible_products, true) && update_all_products(invisible_products, false)
      flash[:notice] = "Marked selected products as visible."
    else
      flash[:error] = "Could not execute your request!"
    end
    respond_with :admin, @collection
  end

  private
  helper_method :sort_column, :sort_direction
  def sort_column
    Product.column_names.include?(params[:s]) ? params[:s] : "collection_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:d]) ? params[:d] : "desc"
  end

  def update_all_products(product_list, visibility)
    products = Product.find(product_list)
    products.each do |p|
      p.update_attribute(:is_visible, visibility) unless p.is_visible == visibility
    end
  end
end

