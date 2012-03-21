class Admin::LookbooksController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :text

  def index
    @search = Lookbook.search(params[:search])
    @lookbooks = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
  end

  def show
    @lookbook = Lookbook.find(params[:id])
    respond_with :admin, @lookbook
  end

  def new
    @lookbook = Lookbook.new
    get_all_products
    respond_with :admin, @lookbook
  end

  def edit
    @lookbook = Lookbook.find(params[:id])
    get_all_products
    respond_with :admin, @lookbook
  end

  def create
    generate_slug(params[:lookbook]["name"])
    @lookbook = Lookbook.new(params[:lookbook])

    if @lookbook.save
      flash[:notice] = 'Lookbook page was successfully created.'
    end
    respond_with :admin, @lookbook
  end

  def update
    generate_slug(params[:lookbook]["name"])
    @lookbook = Lookbook.find(params[:id])

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
    @products = Product.find(:all, :order => 'name')
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
