# -*- encoding : utf-8 -*-
class Admin::ProductsController < Admin::BaseController
  load_and_authorize_resource

  respond_to :html

  def index
    load_data_for_index
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
    # I know this is not the best approach, but after update_attributes I can't know is visibility was change or not
    old_visibility = @product.is_visible

    if @product.update_attributes(params[:product])
      ProductListener.notify_about_visibility([@product], current_admin) if @product.is_visible != old_visibility
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
    @sync_event = SynchronizationEvent.new(name: 'products', user: current_admin.email)

    if @sync_event.save
      redirect_to admin_products_path
    else
      load_data_for_index
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


  private
  helper_method :sort_column, :sort_direction, :product_permalink
  def sort_column
    Product.column_names.include?(params[:s]) ? params[:s] : "collection_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:d]) ? params[:d] : "desc"
  end

  def load_data_for_index
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
    @brands = Product.all.map(&:brand).compact.uniq

    format_date_range
    @products = Product.includes(:details).includes(:profiles).includes(:collection).includes(:pictures)
                       .search(params[:q])
                       .in_category(params[:cat])
                       .in_subcategory(params[:subcat])
                       .in_collection(params[:col])
                       .in_profile(params[:p])
                       .with_brand(params[:brand])
                       .with_visibility(params[:is_visible])
                       .in_sections(params[:visibility])
                       .with_pictures(params[:has_pictures])
                       .in_launch_range(@start_date, @end_date)
                       .by_inventory(params[:inventory_ordenation])
                       .by_sold(params[:sale_ordenation])
                       .with_discount(params[:discount_ordenation])
                       .order(sort_column + " " + sort_direction)
                       .order("collection_id desc, category, name")
                       .paginate(page: params[:page], per_page: 10)
  end

  private
    def format_date_range
      start_date = params[:start_launch_date] || { }
      @start_date = !start_date.has_value?("") && start_date.any?  ? Date.new(start_date["(1i)"].to_i, start_date["(2i)"].to_i, start_date["(3i)"].to_i) : nil

      end_date = params[:end_launch_date] || { }
      @end_date = !end_date.has_value?("") && end_date.any? ? Date.new(end_date["(1i)"].to_i, end_date["(2i)"].to_i, end_date["(3i)"].to_i) : nil
    end
end

