class Admin::LookbooksController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :text

  def index
    @search = Lookbook.search(params[:search])
    @lookbooks = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
  end

  def show
    @lookbook = Lookbook.find(params[:id])
    @lookbook_products = @lookbook.lookbooks_products.joins(:product).includes(:product).order("collection_id desc, category, name")
    respond_with :admin, @lookbook
  end

  def new
    @lookbook = Lookbook.new
    get_all_products
    respond_with :admin, @lookbook
  end

  def edit
    @lookbook = Lookbook.find(params[:id])
    @video = @lookbook.video
    get_all_products
    respond_with :admin, @lookbook
  end

  def create
    generate_slug(params[:lookbook]["name"])
    @lookbook       = Lookbook.new(params[:lookbook])
    @video          = Video.new(params[:video])
    @lookbook.video =  @video

    if @lookbook.save && @video.save
      flash[:notice] = 'Lookbook page was successfully created.'
    end
    respond_with :admin, @lookbook
  end

  def update
    generate_slug(params[:lookbook]["name"])
    @lookbook = Lookbook.find(params[:id])

    if params[:video] && !params[:video]['title'].blank? && !params[:video]['url'].blank?
      if !@lookbook.video.nil?
        @lookbook.video.update_attributes(params[:video])
      else
        @video = Video.new(params[:video])
        @video.save
        @lookbook.video = @video
      end
    end

    if @lookbook.update_attributes(params[:lookbook])
      flash[:notice] = 'Lookbook page was successfully updated.'
    end
    respond_with :admin, @lookbook
  end

  def destroy
    @lookbook = Lookbook.find(params[:id])
    @lookbook.destroy
    respond_with :admin, @lookbook
  end

  def get_all_products
    @products = Product.order("collection_id desc, category, name")
  end

  def product
    @lookbook = Lookbook.find(params[:id])
    get_all_products
    respond_with :admin, @lookbook
  end

  private

  def generate_slug(name)
    params[:lookbook]["slug"] = name.parameterize unless params[:lookbook]["name"].nil?
  end

end
